#!/bin/sh

_get_variables() {
    if [ -z "$1" ]; then echo_danger 'error: some mandatory parameter is missing.\n'; return 1; fi
    # constants, flags and private variables will be ignored
    awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && $2 != "false" && substr($0, 1, 1) != "_")print $1
    } { PREV = $0 }' "$1"
}

