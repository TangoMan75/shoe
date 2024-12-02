#!/bin/sh

_print_commands() {
    # Synopsis: _print_commands [PADDING]
    #  PADDING:  Padding length (default: 12)

    if [ -z "$1" ]; then set -- 12; fi
    echo_warning 'Commands:\n'
    awk -v PADDING="$1" '/^### /{printf"\n\033[33m%s:\033[0m\n",substr($0,5)}
        /^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]",""); # remove leading "function ", round brackets and extra spaces
        FUNCTION = substr($0,1,index($0,"{"));  # truncate string after opening curly brace
        sub("{$","",FUNCTION);                  # remove trailing curly brace
        if (substr(PREV,1,3) == "## " && substr($0,1,1) != "_")  # ignore private functions
        printf "\033[32m  %-*s \033[0m%s\n", PADDING, FUNCTION, substr(PREV,4)
    } { PREV = $0 }' "$0"
    printf '\n'
}

