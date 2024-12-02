#!/bin/sh

_print_flags() {
    # Synopsis: _print_flags [PADDING]
    #  PADDING:  Padding length (default: 12)

    if [ -z "$1" ]; then set -- 12; fi
    echo_warning 'Flags:\n'
    awk -F '=' -v PADDING="$(($1-2))" -v SUCCESS="${SUCCESS}" -v PRIMARY="${PRIMARY}" '/^[a-zA-Z0-9_]+=false$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && substr($0, 1, 1) != "_")
        printf "%s  --%-*s %s%s\n",SUCCESS,PADDING,$1,PRIMARY,substr(PREV,4)
    } { PREV = $0 }' "$0"
    printf '\n'
}

