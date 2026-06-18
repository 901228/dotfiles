local M = {}

M.cpu = {}
M.cpu.cache = { last_update_time = 0, last_result = '' }
---@param wezterm Wezterm
---@param throttle? number
function M.cpu.get(wezterm, throttle)
    -- https://github.com/michaelbrusegard/tabline.wez/blob/main/plugin/tabline/components/window/cpu.lua

    throttle = throttle or 3

    local current_time = os.time()
    if current_time - M.cpu.cache.last_update_time < throttle then return M.cpu.cache.last_result end
    local success, result
    if string.match(wezterm.target_triple, 'windows') ~= nil then
        success, result = wezterm.run_child_process({
            'powershell.exe',
            '-NoProfile',
            '-Command',
            '(Get-CimInstance Win32_Processor).LoadPercentage',
        })
    elseif string.match(wezterm.target_triple, 'linux') ~= nil then
        success, result = wezterm.run_child_process({
            'bash',
            '-c',
            "awk '/^cpu / {print ($2+$4)*100/($2+$4+$5)}' /proc/stat",
        })
    elseif string.match(wezterm.target_triple, 'darwin') ~= nil then
        success, result = wezterm.run_child_process({
            'bash',
            '-c',
            'ps -A -o %cpu | awk \'{s+=$1} END {print s ""}\'',
        })
    end

    if not success or not result then return '' end

    local cpu
    if string.match(wezterm.target_triple, 'windows') ~= nil then
        cpu = result:match('%d+')
    else
        cpu = result:gsub('^%s*(.-)%s*$', '%1')
    end

    if string.match(wezterm.target_triple, 'darwin') ~= nil then
        success, result = wezterm.run_child_process({
            'sysctl',
            '-n',
            'hw.ncpu',
        })
        if success then
            local num_cores = tonumber(result)
            local cpu_num = tonumber(cpu)
            if num_cores and cpu_num then cpu = cpu_num / num_cores end
        end
    end

    cpu = ' ' .. string.format('%4.2f%%', cpu)

    M.cpu.cache.last_update_time = current_time
    M.cpu.cache.last_result = cpu

    return cpu
end

M.ram = {}
M.ram.cache = { last_update_time = 0, last_result = '' }
---@param wezterm Wezterm
---@param throttle? number
function M.ram.get(wezterm, throttle)
    -- https://github.com/michaelbrusegard/tabline.wez/blob/main/plugin/tabline/components/window/ram.lua

    throttle = throttle or 3

    local current_time = os.time()
    if current_time - M.ram.cache.last_update_time < throttle then return M.ram.cache.last_result end
    local success, result
    if string.match(wezterm.target_triple, 'windows') ~= nil then
        success, result = wezterm.run_child_process({
            'powershell.exe',
            '-NoProfile',
            '-Command',
            '(Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory',
        })
    elseif string.match(wezterm.target_triple, 'linux') ~= nil then
        success, result =
            wezterm.run_child_process({ 'bash', '-c', 'free -m | awk \'NR==2{printf "%.2f", $3*100/$2 }\'' })
    elseif string.match(wezterm.target_triple, 'darwin') ~= nil then
        success, result = wezterm.run_child_process({ 'vm_stat' })
    end

    if not success or not result then return '' end

    local ram
    if string.match(wezterm.target_triple, 'linux') ~= nil then
        ram = string.format('%.2f GB', tonumber(result))
    elseif string.match(wezterm.target_triple, 'darwin') ~= nil then
        local page_size = result:match('page size of (%d+) bytes')
        local pages_free = result:match('Pages free: +(%d+).')
        local pages_active = result:match('Pages active: +(%d+).')
        local pages_inactive = result:match('Pages inactive: +(%d+).')
        local pages_speculative = result:match('Pages speculative: +(%d+).')
        local total_memory = (pages_free + pages_active + pages_inactive + pages_speculative)
            * page_size
            / 1024
            / 1024
            / 1024
        ram = string.format('%.2f GB', total_memory)
    elseif string.match(wezterm.target_triple, 'windows') ~= nil then
        ram = result:match('%d+')
        ram = string.format('%.2f GB', tonumber(ram) / 1024 / 1024)
    end

    ram = '  ' .. ram

    M.ram.cache.last_update_time = current_time
    M.ram.cache.last_result = ram

    return ram
end

M.battery = {}
---@param wezterm Wezterm
function M.battery.get(wezterm)
    local bat = ''
    ---@diagnostic disable-next-line: undefined-field
    for _, b in ipairs(wezterm.battery_info()) do
        local percent = b.state_of_charge * 100

        if b.state == 'Charging' then
            if percent > 90 then
                bat = '󰂋'
            elseif percent > 80 then
                bat = '󰂊'
            elseif percent > 70 then
                bat = '󰢞'
            elseif percent > 60 then
                bat = '󰂉'
            elseif percent > 50 then
                bat = '󰢝'
            elseif percent > 40 then
                bat = '󰂈'
            elseif percent > 30 then
                bat = '󰂇'
            elseif percent > 20 then
                bat = '󰂆'
            elseif percent > 10 then
                bat = '󰢜'
            else
                bat = '󰢟'
            end
        elseif b.state == 'Discharging' then
            if percent > 90 then
                bat = '󰂂'
            elseif percent > 80 then
                bat = '󰂁'
            elseif percent > 70 then
                bat = '󰂀'
            elseif percent > 60 then
                bat = '󰁿'
            elseif percent > 50 then
                bat = '󰁾'
            elseif percent > 40 then
                bat = '󰁽'
            elseif percent > 30 then
                bat = '󰁼'
            elseif percent > 20 then
                bat = '󰁻'
            elseif percent > 10 then
                bat = '󰁺'
            else
                bat = '󰂎'
            end
        elseif b.state == 'Empty' then
            bat = '󰂎'
        elseif b.state == 'Full' then
            bat = '󰁹'
        elseif b.state == 'Unknown' then
            bat = '󰂑'
        end
        bat = bat .. ' ' .. string.format('%.0f%%', percent)
    end

    return bat
end

---@param wezterm Wezterm
---@param config Config
---@param tab_bar_bg string
function M.setup(wezterm, config, tab_bar_bg)
    ---@diagnostic disable-next-line: undefined-field
    local nerdfonts = wezterm.nerdfonts
    local SOLID_LEFT_ARROW = nerdfonts.pl_right_hard_divider
    local SOLID_RIGHT_ARROW = nerdfonts.pl_left_hard_divider

    config.use_fancy_tab_bar = false

    ---@alias Tab any

    ---@param tab Tab
    ---@param tabs Tab[]
    ---@param panes Pane[]
    ---@param cfg table
    ---@param hover boolean
    ---@param max_width number
    ---@return any
    wezterm.on('format-tab-title', function(tab, tabs, panes, cfg, hover, max_width)
        local title = tab.tab_title
        title = title and #title > 0 and title or tab.active_pane.title

        local prefix = tostring(tab.tab_index) .. ' ' -- tab index
        local suffix = ' '
        local extra = tab.is_active and 1 or 0 -- active padding
        local arrow = 2 -- trailing arrow

        local reserved = #prefix + #suffix + extra + arrow -- all reserved
        title = #title < max_width - reserved and title or title:sub(1, max_width - reserved - 3) .. '...'
        title = prefix .. title .. suffix

        local edge_background = { Color = tab_bar_bg }
        local background = { Color = tab_bar_bg }
        local foreground = { AnsiColor = 'White' }

        if tab.is_active then
            background = { AnsiColor = 'Blue' }
            foreground = { AnsiColor = 'White' }
            title = ' ' .. title
        elseif hover then
        end

        local edge_foreground = background

        return {
            { Background = edge_foreground },
            { Foreground = edge_background },
            { Text = SOLID_RIGHT_ARROW },

            { Background = background },
            { Foreground = foreground },
            { Text = title },

            { Background = edge_background },
            { Foreground = edge_foreground },
            { Text = tab.is_active and SOLID_RIGHT_ARROW or '' },
        }
    end)

    --- status ---
    ---@param window Window
    ---@param pane Pane
    ---@diagnostic disable-next-line: undefined-field
    wezterm.on('update-status', function(window, pane)
        ---@diagnostic disable-next-line: undefined-field
        window:set_left_status(wezterm.format({
            { Foreground = { AnsiColor = 'Black' } },
            { Background = { AnsiColor = 'Lime' } },
            { Text = ' ' .. string.format('%-3d', window:mux_window():window_id()) },

            { Foreground = { AnsiColor = 'Lime' } },
            { Background = { Color = tab_bar_bg } },
            { Text = SOLID_RIGHT_ARROW },
        }))
    end)

    ---@param window Window
    ---@param pane Pane
    ---@diagnostic disable-next-line: undefined-field
    wezterm.on('update-right-status', function(window, pane)
        ---@diagnostic disable-next-line: undefined-field
        local date = wezterm.strftime('%m/%d %a %H:%M:%S ')

        local compose = ''
        if window:composition_status() then compose = nerdfonts.md_keyboard .. ' ' end

        local leader = ''
        if window:leader_is_active() then leader = nerdfonts.md_apple_keyboard_command .. ' ' end

        ---@diagnostic disable-next-line: undefined-field
        window:set_right_status(wezterm.format({
            { Foreground = { AnsiColor = 'White' } },
            { Background = { Color = tab_bar_bg } },
            { Text = compose },
            { Text = leader },

            { Foreground = { AnsiColor = 'Navy' } },
            { Background = { Color = tab_bar_bg } },
            { Text = ' ' },
            { Text = SOLID_LEFT_ARROW },

            { Foreground = { AnsiColor = 'White' } },
            { Background = { AnsiColor = 'Navy' } },
            { Text = ' ' },
            { Text = date },

            { Foreground = { AnsiColor = 'Fuchsia' } },
            { Background = { AnsiColor = 'Navy' } },
            { Text = ' ' },
            { Text = SOLID_LEFT_ARROW },

            { Foreground = { AnsiColor = 'Black' } },
            { Background = { AnsiColor = 'Fuchsia' } },
            { Text = ' ' },
            { Text = M.ram.get(wezterm, 10) },

            { Foreground = { AnsiColor = 'Red' } },
            { Background = { AnsiColor = 'Fuchsia' } },
            { Text = ' ' },
            { Text = SOLID_LEFT_ARROW },

            { Foreground = { AnsiColor = 'Black' } },
            { Background = { AnsiColor = 'Red' } },
            { Text = ' ' },
            { Text = M.cpu.get(wezterm, 10) },

            { Foreground = { AnsiColor = 'Blue' } },
            { Background = { AnsiColor = 'Red' } },
            { Text = ' ' },
            { Text = SOLID_LEFT_ARROW },

            { Foreground = { AnsiColor = 'Black' } },
            { Background = { AnsiColor = 'Blue' } },
            { Text = ' ' },
            { Text = M.battery.get(wezterm) },

            -- { Text = ' ' },
            { Foreground = { AnsiColor = 'Blue' } },
            { Background = { Color = tab_bar_bg } },
            { Text = nerdfonts.ple_right_half_circle_thick },
        }))
    end)

    -- setup tab_bar_style
    config.tab_bar_style = {
        new_tab = wezterm.format({
            { Background = { Color = tab_bar_bg } },
            { Foreground = { AnsiColor = 'White' } },
            { Text = '  + ' },
        }),
        new_tab_hover = wezterm.format({
            { Background = { Color = tab_bar_bg } },
            { Foreground = { AnsiColor = 'White' } },
            { Text = ' ' },
            { Background = { AnsiColor = 'Silver' } },
            { Foreground = { Color = tab_bar_bg } },
            { Text = ' + ' },
        }),

        -- decorations
        window_hide = wezterm.format({
            { Background = { Color = tab_bar_bg } },
            { Foreground = { AnsiColor = 'White' } },
            { Text = ' ' .. nerdfonts.cod_chrome_minimize ..' ' },
        }),
        window_hide_hover = wezterm.format({
            { Background = { AnsiColor = 'Grey' } },
            { Foreground = { AnsiColor = 'White' } },
            { Text = ' ' .. nerdfonts.cod_chrome_minimize ..' ' },
        }),
        window_maximize = wezterm.format({
            { Background = { Color = tab_bar_bg } },
            { Foreground = { AnsiColor = 'White' } },
            { Text = ' ' .. nerdfonts.cod_chrome_maximize ..' ' },
        }),
        window_maximize_hover = wezterm.format({
            { Background = { AnsiColor = 'Grey' } },
            { Foreground = { AnsiColor = 'White' } },
            { Text = ' ' .. nerdfonts.cod_chrome_maximize ..' ' },
        }),
        window_close = wezterm.format({
            { Background = { Color = tab_bar_bg } },
            { Foreground = { AnsiColor = 'White' } },
            { Text = ' ' .. nerdfonts.cod_chrome_close ..' ' },
        }),
        window_close_hover = wezterm.format({
            { Background = { AnsiColor = 'Red' } },
            { Foreground = { AnsiColor = 'White' } },
            { Text = ' ' .. nerdfonts.cod_chrome_close ..' ' },
        }),
    }

    return config
end

return M
