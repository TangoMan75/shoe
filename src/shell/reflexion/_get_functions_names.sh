#!/bin/sh

## List functions names from provided shoe script
##
## @namespace src/shell/reflexion
## @requires awk realpath
## @depends src/shell/colors/_echo_error.sh
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {bool} <GET_PRIVATE> (default:false) If set to "true", retrieves private functions as well.
_get_functions_names() {
    if [ -z "$1" ]; then _echo_error '_get_functions_names: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_functions_names: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_functions_names: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" "${2:-false}"

    # Matches `name() {`, `name(){`, `name()` alone, `name() { ...; }` on
    # one line and `function name {`.
    awk -v GET_PRIVATE="$2" \
    '/^[a-zA-Z0-9_]+ *\(\)/ || /^function +[a-zA-Z0-9_]+/ {
        function_name=$1
        if (function_name == "function") function_name=$2
        sub(/\(.*/, "", function_name)
        if (GET_PRIVATE == "true") {
            print function_name
        } else {
            if (substr(function_name,1,1) != "_") print function_name
        }
    } {PREV = $0}' "$1"
}

