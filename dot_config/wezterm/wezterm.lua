local wezterm = require('wezterm')

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

--- Colors ---
config.colors = {
    foreground = '#C0C0C0',
    background = '#000000',

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

    -- indexed = { [136] = '#af8700' },

    -- copy_mode_active_highlight_bg = { Color = '#000000' },

    -- copy_mode_active_highlight_fg = { AnsiColor = 'Black' },
    -- copy_mode_inactive_highlight_bg = { Color = '#52ad70' },
    -- copy_mode_inactive_highlight_fg = { AnsiColor = 'White' },

    -- quick_select_label_bg = { Color = 'peru' },
    -- quick_select_label_fg = { Color = '#ffffff' },
    -- quick_select_match_bg = { AnsiColor = 'Navy' },
    -- quick_select_match_fg = { Color = '#ffffff' },compose_cursor = 'orange',
}
-- windows
config.window_background_opacity = 0.7
-- config.window_decorations = 'INTEGRATED_BUTTONS | RESIZE'
config.window_decorations = 'NONE'

-- initial window size
config.initial_cols = 110
config.initial_rows = 32

-- plus tab menu entry
config.launch_menu = {
    {
        args = { 'btop' },
    },
    {
        label = 'Bash',
        args = { 'bash', '-l' },
    }
}

-- front_end
config.front_end = 'WebGpu'
config.webgpu_power_preference = 'HighPerformance'

--- Others ---
config.enable_scroll_bar = true
config.enable_wayland = false
config.quote_dropped_files = 'Posix'
config.term = 'wezterm'

return config

