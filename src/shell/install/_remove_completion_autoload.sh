#!/bin/sh

## Remove completion script autoload
##
## Removes an autoload line for a completion script from a shell rc configuration file
##
## @namespace src/shell/install
## @requires basename printf realpath sed
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/compatibility/_sed_i.sh
## @param {file} <SHELL_CONFIG_FILE> (required) The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
_remove_completion_autoload() {
    if [ $# -lt 1 ]; then _echo_error '_remove_completion_autoload: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_remove_completion_autoload: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_remove_completion_autoload: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" "${2:-"$(basename "$1" .sh)"}"

    # The alias is literal text: escape the regular expression
    # metacharacters so a dot or a bracket cannot widen the match.
    __pattern__="$(printf '%s' "$2" | sed 's@[\\.*^$/[]@\\&@g')" || return 1

    _echo_info "_sed_i \"/^###> ${__pattern__}$/,/^###< ${__pattern__}$/d\" \"$1\"\n"
    _sed_i "/^###> ${__pattern__}$/,/^###< ${__pattern__}$/d" "$1" || return 1

    # collapse blank lines
    # The N command reads the next line into the pattern space (the line being processed).
    # The remaining expression checks if the pattern space now consists of two empty lines (^\n$).
    _sed_i '/^$/{N;s/^\n$//;}' "$1" || return 1
}

