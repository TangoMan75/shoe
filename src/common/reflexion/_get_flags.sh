#!/bin/sh

# List flags from provided shoe script
_get_flags() {
    # Synopsis: _get_flags <SCRIPT_PATH> [GET_PRIVATE]
    #   SCRIPT_PATH: The path to the input script.
    #   GET_PRIVATE: (Optional) If set to 'true', retrieves private functions as well. Defaults to "false".

    if [ -z "$1" ]; then echo_danger 'error: _get_flags: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_flags: too many arguments (${#})\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-false}"
    if [ ! -f "$1" ]; then echo_danger "error: _get_flags: \"$1\" file not found\n"; return 1; fi

    awk -F '=' -v GET_PRIVATE="$2" '/^[a-zA-Z0-9_]+=false$/ {
        if (GET_PRIVATE == "true") {
            if ($1 != toupper($1)) print $1
        } else {
            if (substr(PREV,1,3) == "## " && $1 != toupper($1) && substr($0,1,1) != "_") print $1
        }
    } { PREV = $0 }' "$1"
}

