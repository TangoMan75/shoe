#!/bin/sh

# Get function annotation by name
_get_function_annotation() {
    # Synopsis: _get_function_annotation <SCRIPT_PATH> <FUNCTION_NAME>
    #   SCRIPT_PATH:   The path to the input file.
    #   FUNCTION_NAME: The name of the function to retrieve.

    if [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: _get_function_annotation: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_function_annotation: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"
    if [ ! -f "$1" ]; then echo_danger "error: _get_function_annotation: \"$1\" file not found\n"; return 1; fi

    awk -v FUNCTION_NAME="$2" '
        /^#/ { annotation=annotation"\n"$0 }
        /^(function +)?[a-zA-Z0-9_]+ *\(\)/ {           # matches a function (ignoring curly braces)
            function_name=substr($0,1,index($0,"(")-1); # truncate string at opening round bracket
            sub("^function ","",function_name);         # remove leading "function " if present
            gsub(" +","",function_name);                # trim whitespaces
            if (function_name==FUNCTION_NAME) print substr(annotation,2); # print annotation (without leading "\n")
        }
        !/^#/ { annotation="" }
    ' "$1"
}

