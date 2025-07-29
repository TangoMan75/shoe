#!/bin/sh

# Remove completion script autoload
_remove_completion_autoload() {
    # Synopsis: _remove_completion_autoload <SHELL_CONFIG_FILE> [ALIAS]
    # Removes an autoload line for a completion script from a shell configuration file.
    #   SHELL_CONFIG_FILE: The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).
    #   ALIAS:             (optional) The alias of the script to remove. Defaults to the basename of the provided file

    if [ ${#} -lt 1 ]; then echo_danger 'error: _remove_completion_autoload: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _remove_completion_autoload: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"
    if [ ! -f "$1" ]; then echo_danger "error: _remove_completion_autoload: \"$1\" file not found\n"; return 1; fi

    echo_info "$(_sed_i) \"/^###> $2$/,/^###< $2$/d\" \"$1\"\n"
    $(_sed_i) "/^###> $2$/,/^###< $2$/d" "$1"

    # collapse blank lines
    # The N command reads the next line into the pattern space (the line being processed).
    # The remaining expression checks if the pattern space now consists of two empty lines (^\n$).
    $(_sed_i) '/^$/{N;s/^\n$//;}' "$1"
}

