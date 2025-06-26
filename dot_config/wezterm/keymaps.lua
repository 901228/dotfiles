local M = {}

---@param wezterm Wezterm
---@param config Config
function M.setup(wezterm, config)
    -- config.disable_default_key_bindings = true

    config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

    local act = wezterm.action
    config.keys = {
        -- command palette
        {
            key = 'P',
            mods = 'CTRL',
            action = 'ActivateCommandPalette',
        },

        -- splitting
        {
            key = '|',
            mods = 'LEADER|SHIFT',
            action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
        },
        {
            key = '-',
            mods = 'LEADER',
            action = act.SplitVertical({ domain = 'CurrentPaneDomain' }),
        },

        -- change tab
        {
            key = 'l',
            mods = 'LEADER',
            action = act.ActivateTabRelative(1),
        },
        {
            key = 'h',
            mods = 'LEADER',
            action = act.ActivateTabRelative(-1),
        },
        {
            key = 't',
            mods = 'CTRL|LEADER',
            action = act.SpawnTab('CurrentPaneDomain'),
        },
        {
            key = 't',
            mods = 'LEADER',
            action = act.SpawnTab('CurrentPaneDomain'),
        },

        -- resize mode
        {
            key = 'r',
            mods = 'LEADER',
            action = act.ActivateKeyTable({
                name = 'resize_pane',
                one_shot = false,
                prevent_fallback = false,
                replace_current = false,
                until_unknown = false,
            }),
        },

        -- resize pane directly
        { key = 'H', mods = 'LEADER', action = act.AdjustPaneSize({ 'Left', 3 }) },
        { key = 'L', mods = 'LEADER', action = act.AdjustPaneSize({ 'Right', 3 }) },
        { key = 'K', mods = 'LEADER', action = act.AdjustPaneSize({ 'Up', 3 }) },
        { key = 'J', mods = 'LEADER', action = act.AdjustPaneSize({ 'Down', 3 }) },

        -- change pane mode
        {
            key = 'a',
            mods = 'LEADER',
            action = act.ActivateKeyTable({
                name = 'activate_pane',
                one_shot = true,
                prevent_fallback = false,
                replace_current = false,
                timeout_milliseconds = 1000,
                until_unknown = false,
            }),
        },

        -- change pane directly
        { key = 'LeftArrow', mods = 'ALT', action = act.ActivatePaneDirection('Left') },
        { key = 'h', mods = 'ALT', action = act.ActivatePaneDirection('Left') },

        { key = 'RightArrow', mods = 'ALT', action = act.ActivatePaneDirection('Right') },
        { key = 'l', mods = 'ALT', action = act.ActivatePaneDirection('Right') },

        { key = 'UpArrow', mods = 'ALT', action = act.ActivatePaneDirection('Up') },
        { key = 'k', mods = 'ALT', action = act.ActivatePaneDirection('Up') },

        { key = 'DownArrow', mods = 'ALT', action = act.ActivatePaneDirection('Down') },
        { key = 'j', mods = 'ALT', action = act.ActivatePaneDirection('Down') },
    }

    -- key tables
    config.key_tables = {
        resize_pane = {
            { key = 'LeftArrow', action = act.AdjustPaneSize({ 'Left', 1 }) },
            { key = 'h', action = act.AdjustPaneSize({ 'Left', 1 }) },

            { key = 'RightArrow', action = act.AdjustPaneSize({ 'Right', 1 }) },
            { key = 'l', action = act.AdjustPaneSize({ 'Right', 1 }) },

            { key = 'UpArrow', action = act.AdjustPaneSize({ 'Up', 1 }) },
            { key = 'k', action = act.AdjustPaneSize({ 'Up', 1 }) },

            { key = 'DownArrow', action = act.AdjustPaneSize({ 'Down', 1 }) },
            { key = 'j', action = act.AdjustPaneSize({ 'Down', 1 }) },

            -- Cancel the mode by pressing escape
            { key = 'Escape', action = 'PopKeyTable' },
        },

        activate_pane = {
            { key = 'LeftArrow', action = act.ActivatePaneDirection('Left') },
            { key = 'h', action = act.ActivatePaneDirection('Left') },

            { key = 'RightArrow', action = act.ActivatePaneDirection('Right') },
            { key = 'l', action = act.ActivatePaneDirection('Right') },

            { key = 'UpArrow', action = act.ActivatePaneDirection('Up') },
            { key = 'k', action = act.ActivatePaneDirection('Up') },

            { key = 'DownArrow', action = act.ActivatePaneDirection('Down') },
            { key = 'j', action = act.ActivatePaneDirection('Down') },
        },
    }

    return config
end

return M
