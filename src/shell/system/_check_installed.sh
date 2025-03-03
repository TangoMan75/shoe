#!/bin/sh

# Print error message if provided command is missing
#
# {
#   "namespace": "system",
#   "depends": [
#     "_get_package_name",
#     "_is_installed",
#     "echo_danger"
#   ],
#   "parameters": [
#     {
#       "position": 1,
#       "name": "COMMAND",
#       "type": "str",
#       "description": "A string containing the command name to find.",
#       "nullable": false
#     }
#   ]
# }
_check_installed() {
    # Synopsis: _check_installed <COMMAND>
    #   COMMAND: A string containing the command name to find.

    if [ -z "$1" ]; then echo_danger 'error: _check_installed: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _check_installed: too many arguments (${#})\n"; return 1; fi

    if _is_installed "$1"; then
        return 0
    fi

    # set default values
    set -- "$1" "$(_get_package_name "$1")"

    echo_danger "error: \"$(basename "${0}")\" requires $1, try: 'sudo apt-get install -y $2'\n"

    exit 1
}

