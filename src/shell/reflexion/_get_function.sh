#!/bin/sh

# Get function by name
#
# {
#   "namespace": "reflexion",
#   "requires": [
#     "awk"
#   ],
#   "depends": [
#     "echo_danger"
#   ],
#   "parameters": [
#     {
#       "position": 1,
#       "name": "SCRIPT_PATH",
#       "type": "file",
#       "description": "The path to the input script.",
#       "nullable": false
#     },
#     {
#       "position": 2,
#       "name": "FUNCTION_NAME",
#       "type": "str",
#       "description": "The name of the function to retrieve.",
#       "nullable": false
#     }
#   ]
# }
_get_function() {
    # Synopsis: _get_function <SCRIPT_PATH> <FUNCTION_NAME>
    #   SCRIPT_PATH:   The path to the input file.
    #   FUNCTION_NAME: The name of the function to retrieve.

    if [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: _get_function: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_function: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"
    if [ ! -f "$1" ]; then echo_danger "error: _get_function: \"$1\" file not found\n"; return 1; fi

    awk -v FUNCTION_NAME="$2" '
    function count_occurrences(str,char) {
        gsub("\\.","",str); # remove escaped characters
        gsub(/"[^"]*"/,""); # remove quoted string
        return gsub(char,char,str);
    }
    /^#/ { annotation=annotation"\n"$0 }
    in_function {
        print $0;
        count=count_occurrences($0,"{")-count_occurrences($0,"}");
        # count+=gsub("{","&")-gsub("}","&");
        if (count==0) exit
    }
    /^(function +)?[a-zA-Z0-9_]+ *\(\)/ {           # matches a function (ignoring curly braces)
        function_name=substr($0,1,index($0,"(")-1); # truncate string at opening round bracket
        sub("^function ","",function_name);         # remove leading "function " if present
        gsub(" +","",function_name);                # trim whitespaces
        if (function_name==FUNCTION_NAME) {
            if (annotation!="") print substr(annotation,2); # print annotation (without leading "\n")
            print $0;
            in_function=1;
            count=count_occurrences($0,"{")-count_occurrences($0,"}"); # count opened and closed curly braces on current line
            # count=gsub("{","&")-gsub("}","&"); # count opened and closed curly braces on current line
        }
    }
    !/^#/ { annotation="" }' "$1"
}

