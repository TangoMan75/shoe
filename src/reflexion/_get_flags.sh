#!/bin/sh

_get_flags() {
    if [ -z "$1" ]; then echo_danger 'error: some mandatory parameter is missing.\n'; return 1; fi
    # flags are just regular variables with a value set to "false"
    awk -F '=' '/^[a-zA-Z0-9_]+=false$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && substr($0, 1, 1) != "_") print $1
    } { PREV = $0 }' "$1"
}

