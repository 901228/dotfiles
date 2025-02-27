# config.nu
#
# Installed by:
# version = "0.101.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

# Theme
source ($nu.data-dir | path join "themes/catppuccin-mocha.nu")

# Modules
use ($nu.data-dir | path join "modules/conda.nu")
use ($nu.data-dir | path join "modules/venv.nu")
use ($nu.data-dir | path join "modules/nu_msvs.nu")

# Completions
source ($nu.data-dir | path join "completions/adb-completions.nu")
source ($nu.data-dir | path join "completions/bat-completions.nu")
source ($nu.data-dir | path join "completions/cargo-completions.nu")
source ($nu.data-dir | path join "completions/composer-completions.nu")
source ($nu.data-dir | path join "completions/curl-completions.nu")
source ($nu.data-dir | path join "completions/docker-completions.nu")
source ($nu.data-dir | path join "completions/dotnet-completions.nu")
source ($nu.data-dir | path join "completions/eza-completions.nu")
source ($nu.data-dir | path join "completions/flutter-completions.nu")
source ($nu.data-dir | path join "completions/git-completions.nu")
source ($nu.data-dir | path join "completions/make-completions.nu")
source ($nu.data-dir | path join "completions/man-completions.nu")
source ($nu.data-dir | path join "completions/nix-completions.nu")
source ($nu.data-dir | path join "completions/npm-completions.nu")
source ($nu.data-dir | path join "completions/rg-completions.nu")
source ($nu.data-dir | path join "completions/rustup-completions.nu")
source ($nu.data-dir | path join "completions/scoop-completions.nu")
source ($nu.data-dir | path join "completions/ssh-completions.nu")
source ($nu.data-dir | path join "completions/tar-completions.nu")
source ($nu.data-dir | path join "completions/winget-completions.nu")
source ($nu.data-dir | path join "completions/yarn-v4-completions.nu")
source ($nu.data-dir | path join "completions/pip-completions.nu")

# Hooks
# $env.config.hooks = {
#     command_not_found: (source ($nu.data-dir | path join "hooks/did_you_mean.nu"))
# }

# Keybidings
$env.config.keybindings = [
    {
        name: trigger-completion-menu
        modifier: none
        keycode: tab
        mode: [emacs vi_normal vi_insert]
        event: {
            until: [
                { send: menu name: completion_menu }
                { send: menunext }
            ]
        }
    }
]

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
            text: "#4bff5c"                            # Text style
            selected_text: { fg: "#4bff5c" attr: rb }  # Text style for selected option
            description_text: "yellow"                 # Text style for description
        }
    }
]

# Completers
let fish_completer = {|spans|
    fish --command $'complete "--do-complete=($spans | str join " ")"'
    | from tsv --flexible --noheaders --no-infer
    | rename value description
}

# let carapace_completer = {|spans: list<string>|
#     carapace $spans.0 nushell ...$spans
#     | from json
#     | if ($in | default [] | where value == $"($spans | last)ERR" | is-empty) { $in } else { null }
# }

# This completer will use carapace by default
let external_completer = {|spans|
    let expanded_alias = scope aliases
    | where name == $spans.0
    | get -i 0.expansion

    let spans = if $expanded_alias != null {
        $spans
        | skip 1
        | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    match $spans.0 {
        # carapace completions are incorrect for nu
        nu => $fish_completer
        # fish completes commits and branch names in a nicer way
        git => $fish_completer
        # carapace doesn't have completions for asdf
        asdf => $fish_completer
        # _ => $carapace_completer
        _ => $fish_completer
    } | do $in $spans
}

$env.config.completions = {
    external: {
        enable: true
        completer: $external_completer
    }
}

# Others
$env.config.buffer_editor = "nvim"
$env.config.show_banner = false

# Add the following to the end of your Nushell configuration
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
