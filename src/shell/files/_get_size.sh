#!/bin/sh

## Print the human readable size of a file or folder
##
## @namespace src/shell/files
## @requires du realpath
## @depends src/shell/colors/_echo_error
## @param {path} <SOURCE> (required) The file or folder to measure.
_get_size() {
    if [ -z "$1" ]; then _echo_error '_get_size: some mandatory parameter is missing\n'; return 1; fi
    if [ "$#" -gt 1 ]; then _echo_error "_get_size: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ] && [ ! -d "$1" ]; then
        _echo_error "_get_size: \"$1\" is invalid\n"

        return 1
    fi

    set -- "$(realpath "$1")"

    du -sh "$1"
}

