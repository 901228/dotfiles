local wezterm = require('wezterm') --[[@as Wezterm]]

---@type Config
---@diagnostic disable-next-line: missing-fields
local config = {}

local Appearance = require('appearance')

--- Font ---
config = Appearance.font.setup(wezterm, config)

--- Colors ---
local tab_bar_bg = '#11111b'
config = Appearance.colorscheme.setup(wezterm, config, tab_bar_bg)

--- Windows ---
config = Appearance.window.setup(wezterm, config)

--- Tab bar ---
config = Appearance.tabbar.setup(wezterm, config, tab_bar_bg)

-- plus tab menu entry
config.launch_menu = {
    ---@diagnostic disable-next-line: missing-fields
    {
        label = 'Zsh',
        args = { 'zsh', '-l' },
    },
    ---@diagnostic disable-next-line: missing-fields
    {
        label = 'Btop',
        args = { 'btop' },
    },
    ---@diagnostic disable-next-line: missing-fields
    {
        label = 'Bash',
        args = { 'bash', '-l' },
    },
}

-- front_end
config.front_end = 'WebGpu'
config.webgpu_power_preference = 'HighPerformance'

--- Others ---
config.enable_wayland = false

---@diagnostic disable-next-line: assign-type-mismatch
config.quote_dropped_files = 'Posix'
-- config.term = 'wezterm'

--- keymaps ---
config = require('keymaps').setup(wezterm, config)

-- integration with neovim
local smart_splits = wezterm.plugin.require('https://github.com/mrjones2014/smart-splits.nvim')
smart_splits.apply_to_config(config, {
    direction_keys = { 'h', 'j', 'k', 'l' },
    modifiers = {
        move = 'META', -- modifier to use for pane movement, e.g. CTRL+h to move left
        resize = 'SHIFT', -- modifier to use for pane resize, e.g. META+h to resize to the left
    },
    log_level = 'info',
})

return config
