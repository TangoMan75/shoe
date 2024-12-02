#!/bin/sh

_print_constants() {
    # Synopsis: _print_constants [PADDING]
    #  PADDING:  Padding length (default: 12)

    if [ -z "$1" ]; then set -- 12; fi
    echo_warning 'Constants:\n'
    awk -F '=' -v PADDING="$1" -v SUCCESS="${SUCCESS}" -v PRIMARY="${PRIMARY}" -v INFO="${INFO}" -v WARNING="${WARNING}" -v EOL="${EOL}" '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV, 1, 3) == "## " && $1 == toupper($1) && substr($0, 1, 1) != "_")
        printf "%s  %-*s %s%s%s (value: %s%s%s)%s",SUCCESS,PADDING,$1,PRIMARY,substr(PREV,4),INFO,WARNING,$2,INFO,EOL
    } { PREV = $0 }' "$0"
    printf '\n'
}

