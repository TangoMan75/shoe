#!/bin/sh

## Print error message if provided command is missing
##
## @namespace src/shell/system
## @requires basename
## @depends src/shell/colors/_echo_error src/shell/system/_get_package_name src/shell/system/_is_installed
## @param {str} <COMMAND> (required) A string containing the command name to find.
_check_installed() {
    if [ -z "$1" ]; then _echo_error '_check_installed: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_check_installed: too many arguments ($#)\n"; return 1; fi

    if _is_installed "$1"; then
        return 0
    fi

    # set default values
    set -- "$1" "$(_get_package_name "$1")"

    _echo_error "\"$(basename "${0}")\" requires $1, try: 'sudo apt-get install -y $2'\n"

    exit 1
}

