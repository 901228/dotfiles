# for light mode additional settings

source ($nu.data-dir | path join "themes/catppuccin-latte.nu")


# Menus
$env.config.menus = [
    {
        name: completion_menu
        only_buffer_difference: false  # Search is done on the text written after activating the menu
        marker: ""                     # Indicator that appears with the menu is active
        type: {
            layout: columnar  # Type of menu
            columns: 4        # Number of columns where the options are displayed
            col_width: 20     # Optional value. If missing all the screen width is used to calculate column width
            col_padding: 2    # Padding between columns
        }
        style: {
            text: "green"                            # Text style
            selected_text: { fg: "green" attr: rb }  # Text style for selected option
            description_text: "yellow"                 # Text style for description
        }
    }
]
