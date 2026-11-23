#!/bin/sh

## Exit with an error when a script defines a function more than once
##
## @namespace src/shell/validation
## @requires grep printf
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/reflexion/_get_functions_names.sh
## @param {file} <SCRIPT_PATH> (required) The path to the script to inspect.
_check_duplicate_functions() {
    if [ -z "$1" ]; then _echo_error '_check_duplicate_functions: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_check_duplicate_functions: too many arguments ($#)\n"; return 1; fi

    __functions_names__=$(_get_functions_names "$1" 'true')

    for __function__ in ${__functions_names__}; do
        if [ "$(printf '%s' "${__functions_names__}" | grep -cx "${__function__}")" -gt 1 ]; then
            _echo_error "function \"${__function__}\" is defined multiple times\n"
            exit 1
        fi
    done

    return 0
}

