#!/bin/sh

## Get value for given parameter from provided ".env" or ".sh" file
##
## @namespace src/shell/reflexion
## @requires realpath sed
## @depends src/shell/colors/_echo_error
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <KEY> (required) The variable name to get from provided file.
_get_parameter() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_get_parameter: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_parameter: too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_get_parameter: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"
    sed -n "s/^$2=\(.*\)/\1/p" "$1" | sed 's/^"//; s/"$//' # remove leading and trailing quotes
}

