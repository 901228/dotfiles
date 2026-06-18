local M = {}

M.font = {}

---@param wezterm Wezterm
---@param config Config
function M.font.setup(wezterm, config)
    -- font family
    config.font = wezterm.font_with_fallback({
        'MesloLGS Nerd Font',
        'FakePearl',
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

    return config
end

M.colorscheme = {}

---@param wezterm Wezterm
function M.colorscheme.get_color_scheme(wezterm)
    if wezterm.gui.get_appearance():find('Dark') then
        return 'Catppuccin Mocha'
    else
        return 'Catppuccin Latte'
    end
end

---@param wezterm Wezterm
---@param config Config
---@param tab_bar_bg string
---@diagnostic disable-next-line: unused-local
function M.colorscheme.setup(wezterm, config, tab_bar_bg)
    -- config.color_scheme = M.colorscheme.get_color_scheme(wezterm)
    config.color_scheme = 'Catppuccin Mocha'

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

    return config
end

M.window = {}

---@param wezterm Wezterm
---@param config Config
function M.window.setup(wezterm, config)
    config.window_background_opacity = 0.75

    ---@diagnostic disable-next-line: missing-fields
    config.window_frame = {
        font = wezterm.font({ family = 'Roboto', weight = 'Regular' }),
        font_size = 12.0,

        -- border width
        border_left_width = '0.5cell',
        border_right_width = '0.5cell',
        border_bottom_height = '0.25cell',
        border_top_height = '0.25cell',

        -- border color
        border_left_color = 'skyblue',
        border_right_color = 'skyblue',
        border_bottom_color = 'skyblue',
        border_top_color = 'skyblue',
    }
    config.window_padding = {
        left = '0.5cell',
        right = '0.5cell',
        top = '0.25cell',
        bottom = 0,
    }

    -- initial window size
    config.initial_cols = 110
    config.initial_rows = 32

    -- decorations
    config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
    config.integrated_title_button_style = 'Gnome'
    config.integrated_title_button_color = 'Auto'
    config.integrated_title_buttons = { 'Hide', 'Maximize', 'Close' }

    -- others
    config.enable_scroll_bar = true

    return config
end

return M
