#!/bin/sh

## Edit a file in place with the system sed
##
## BSD sed (macOS) requires an empty backup suffix after "-i", GNU sed
## does not. Both forms are supported here.
##
## @namespace src/shell/compatibility
## @requires command sed uname
## @depends src/shell/colors/_echo_error.sh
## @param {str} <EXPRESSION> (required) The sed expression.
## @param {file} <FILE_PATH> (required) The file to edit.
_sed_i() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        _echo_error '_sed_i: some mandatory parameter is missing\n'

        return 1
    fi
    if [ $# -gt 2 ]; then
        _echo_error "_sed_i: too many arguments ($#)\n"

        return 1
    fi
    if [ ! -f "$2" ]; then
        _echo_error "_sed_i: \"$2\" file not found\n"

        return 1
    fi

    if [ "$(uname)" = 'Darwin' ] \
        && [ -n "$(command -v sed)" ] \
        && [ -z "$(sed --version 2>/dev/null)" ]; then
        sed -i '' -e "$1" "$2"

        return $?
    fi

    sed -i -e "$1" "$2"
}

