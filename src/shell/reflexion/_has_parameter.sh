#!/bin/sh

## Tests if parameter exists in provided ".env" or ".sh" file
##
## @namespace src/shell/reflexion
## @requires grep realpath
## @depends src/shell/colors/_echo_error.sh
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <KEY> (required) The variable name to get from provided file.
_has_parameter() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_has_parameter: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_has_parameter: too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_has_parameter: \"$1\" file not found\n"; return 1; fi

    # A parameter name is an identifier: validating it keeps the pattern
    # below literal (an unvalidated key would be a regular expression).
    if [ -z "$2" ] \
        || [ "$2" != "${2#[!A-Za-z_]}" ] \
        || [ "$2" != "${2#*[!A-Za-z0-9_]*}" ]; then
        _echo_error "_has_parameter: invalid parameter name \"$2\"\n"

        return 1
    fi

    set -- "$(realpath -- "$1")" "$2"
    grep -q "^$2=" "$1"
}

