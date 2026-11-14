#!/bin/sh

## Tests if parameter exists in provided ".env" or ".sh" file
##
## @namespace src/shell/reflexion
## @requires grep realpath
## @depends src/shell/colors/_echo_error
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <KEY> (required) The variable name to get from provided file.
_has_parameter() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_has_parameter: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_has_parameter: too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_has_parameter: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"
    grep -q "^${2}=" "$1"
}

