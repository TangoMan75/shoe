#!/bin/sh

## Get function by name
_get_function() {
    if [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: some mandatory parameter is missing.\n'; return 1; fi
    set -- "$1" "$(realpath "$2")"
    # this regular expression matches functions with either bash or sh syntax
    awk -v FUNCTION_NAME="$1" '/^(function )?[a-zA-Z0-9_]+ *\(\) *\{.*/ {
        function_name = substr($0, 1, index($0, "{"));
        gsub("[ (){]", "", function_name);
        sub("^function ", "", function_name);
        if (substr(PREV, 1, 3) == "## ") description=PREV;
        in_function=1;
        if (match($0, /.*\}$/)) print_body=1
    } in_function {
        body = body $0"\n"
    } /^}$/ && in_function {
        print_body=1
    } print_body {
        if (function_name == FUNCTION_NAME) {
            if (description) print description;
            print body
        }
        print_body=0; in_function=0; description=""; body=""
    } { PREV = $0 }' "$2"
}

