local wezterm = require('wezterm') --[[@as Wezterm]]

---@type Config
---@diagnostic disable-next-line: missing-fields
local config = {}

--- Font ---
-- font family
config.font = wezterm.font_with_fallback({
    'MesloLGS Nerd Font',
    'jf-openhuninn-2.0',
    'Cica',
    'Noto Sans Mono CJK TC',
    'Noto Color Emoji',
    'monospace',
    'sans-serif',
    'serif',
})

-- freetype
config.freetype_load_target = 'Light'
config.freetype_render_target = 'Light'
config.freetype_load_flags = 'MONOCHROME'

-- glyphs
config.custom_block_glyphs = true
config.anti_alias_custom_block_glyphs = true

-- others
config.log_unknown_escape_sequences = true
config.normalize_output_to_unicode_nfc = true

--- colors ---
-- local function get_color_scheme()
--     if wezterm.gui.get_appearance():find('Dark') then
--         return 'Catppuccin Mocha'
--     else
--         return 'Catppuccin Latte'
--     end
-- end
-- config.color_scheme = get_color_scheme()
config.color_scheme = 'Catppuccin Mocha'

local tab_bar_bg = '#11111b'
---@diagnostic disable-next-line: missing-fields
config.colors = {
    cursor_bg = '#1E90FF',
    cursor_fg = '#323232',
    cursor_border = '#40DB85',

    selection_fg = '#C0C0C0',
    selection_bg = 'rgba(30, 144, 255, 0.35)',

    scrollbar_thumb = '#CCCCCC',

    split = '#CCCCCC',

    ansi = {
        '#000000',
        '#CD3131',
        '#0BDA51',
        '#FFD700',
        '#6495ED',
        '#B030B0',
        '#40E0D0',
        '#C0C0C0',
    },
    brights = {
        '#808080',
        '#FF7F50',
        '#00FF7F',
        '#FFFF57',
        '#00BFFF',
        '#EEB2EE',
        '#00FFFF',
        '#FFFFFF',
    },

    tab_bar = {
        new_tab = {
            bg_color = tab_bar_bg,
            fg_color = 'White',
        },
        new_tab_hover = {
            bg_color = 'Grey',
            fg_color = tab_bar_bg,
        },
    },
}
-- windows
config.window_background_opacity = 0.75
---@diagnostic disable-next-line: missing-fields
config.window_frame = {
    ---@diagnostic disable-next-line: missing-fields
    font = wezterm.font({ family = 'Roboto', weight = 'Regular' }),
    font_size = 12.0,
}
config.window_padding = {
    left = '0.5cell',
    right = '0.5cell',
    top = '0.25cell',
    -- bottom = '0.25cell',
    bottom = 0,
}

config = require('tab_bar').setup(wezterm, config, tab_bar_bg)

-- initial window size
config.initial_cols = 110
config.initial_rows = 32

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
config.enable_scroll_bar = true
config.enable_wayland = false

---@diagnostic disable-next-line: assign-type-mismatch
config.quote_dropped_files = 'Posix'
-- config.term = 'wezterm'

--- Key bindings ---
local act = wezterm.action
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
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
