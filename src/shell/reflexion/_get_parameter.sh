#!/bin/sh

## Get value for given parameter from provided ".env" or ".sh" file
##
## @namespace src/shell/reflexion
## @requires realpath sed
## @depends src/shell/colors/_echo_error.sh
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <KEY> (required) The variable name to get from provided file.
_get_parameter() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_get_parameter: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_parameter: too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_get_parameter: \"$1\" file not found\n"; return 1; fi

    # The key is interpolated into a sed pattern: reject anything that is
    # not a shell identifier first.
    if [ -z "$2" ] \
        || [ "$2" != "${2#[!A-Za-z_]}" ] \
        || [ "$2" != "${2#*[!A-Za-z0-9_]*}" ]; then
        _echo_error "_get_parameter: invalid parameter name \"$2\"\n"

        return 1
    fi

    set -- "$(realpath -- "$1")" "$2"

    # Values written by _set_parameter are single-quoted, older files may
    # use double quotes. Both are stripped, and the '\'' sequence written
    # for an embedded quote is turned back into a plain quote, so the
    # write/read round-trip is lossless.
    sed -n "s/^$2=\(.*\)/\1/p" "$1" \
        | sed -e "s/'\\\\''/'/g" \
            -e "s/^'//" -e "s/'\$//" -e 's/^"//' -e 's/"$//'
}

