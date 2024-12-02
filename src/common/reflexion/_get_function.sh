#!/bin/sh

# Get function by name
_get_function() {
    # Synopsis: _get_function <SCRIPT_PATH> <FUNCTION_NAME>
    #   SCRIPT_PATH:   The path to the input file.
    #   FUNCTION_NAME: The name of the function to retrieve.

    if [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: _get_function: some mandatory parameter is missing\n'; exit 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _get_function: \"$1\" file not found\n"; exit 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_function: too many arguments (${#})\n"; exit 1; fi

    # this regular expression matches functions with either bash or sh syntax
    awk -v FUNCTION_NAME="$2" '/^(function )?[a-zA-Z0-9_]+ *\(\) *\{.*/ {
        function_name = substr($0,1,index($0,"{"));
        gsub("[ (){]","",function_name);
        sub("^function ","",function_name);
        if (substr(PREV,1,3) == "## ") description=PREV;
        in_function=1;
        if (match($0,/.*\}$/)) print_body=1
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
    } { PREV = $0 }' "$1"
}

