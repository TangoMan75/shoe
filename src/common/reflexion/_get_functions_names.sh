#!/bin/sh

_get_functions_names() {
    # Synopsis: _get_functions_names [script_path] (get_private default=false)
    if [ -z "$1" ]; then echo_danger 'error: _get_functions_names: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_functions_names: too many arguments (${#})\n"; exit 1; fi
    set -- "$(realpath "$1")" "$2"

    # this regular expression matches functions with either bash or sh syntax
    awk -v GET_PRIVATE="$2" '/^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]",""); # remove leading "function ", round brackets and extra spaces
        FUNCTION = substr($0,1,index($0,"{"));  # truncate string after opening curly brace
        sub("{$","",FUNCTION);                  # remove trailing curly brace
        if (GET_PRIVATE == "true") {
            print FUNCTION
        } else {
            if (substr(PREV,1,3) == "## " && substr($0,1,1) != "_") print FUNCTION
        }
    } { PREV = $0 }' "$1"
}

