#!/bin/sh

## {
##   "namespace": "src/shell/install",
##   "summary": "Remove completion script autoload",
##   "description": "Removes an autoload line for a completion script from a shell rc configuration file",
##   "requires": [
##     "basename",
##     "realpath"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info",
##     "src/shell/compatibility/_sed_i"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "SHELL_CONFIG_FILE",
##       "description": "The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).",
##       "type": "file",
##       "required": true
##     },
##     {
##       "position": 2,
##       "name": "ALIAS",
##       "description": "The alias of the script to install. Defaults to the basename of the provided file.",
##       "type": "str"
##     }
##   ]
## }
_remove_completion_autoload() {
    if [ $# -lt 1 ]; then _echo_error '_remove_completion_autoload: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_remove_completion_autoload: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"
    if [ ! -f "$1" ]; then _echo_error "_remove_completion_autoload: \"$1\" file not found\n"; return 1; fi

    _echo_info "$(_sed_i) \"/^###> $2$/,/^###< $2$/d\" \"$1\"\n"
    $(_sed_i) "/^###> $2$/,/^###< $2$/d" "$1"

    # collapse blank lines
    # The N command reads the next line into the pattern space (the line being processed).
    # The remaining expression checks if the pattern space now consists of two empty lines (^\n$).
    $(_sed_i) '/^$/{N;s/^\n$//;}' "$1"
}

