#!/bin/sh

_get_options() {
    # Synopsis: _get_options [script_path] (get_private default=false)
    if [ -z "$1" ]; then echo_danger 'error: _get_options: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_options: too many arguments (${#})\n"; exit 1; fi
    set -- "$(realpath "$1")" "$2"

    awk -F '=' -v GET_PRIVATE="$2" '/^[a-zA-Z0-9_]+=.+$/ {
        if (GET_PRIVATE == "true") {
            if ($1 != toupper($1) && $2 != "false") print $1
        } else {
            if (substr(PREV,1,3) == "## " && $1 != toupper($1) && $2 != "false" && substr($0,1,1) != "_") print $1
        }
    } { PREV = $0 }' "$1"
}

