#!/bin/sh

## Get file extension
##
## @namespace src/shell/files
## @requires grep printf
## @depends src/shell/colors/_echo_error
## @param {file} <FILE_PATH> (required) The path to the input file.
_get_file_extension() {
    if [ -z "$1" ]; then _echo_error '_get_file_extension: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_file_extension: too many arguments ($#)\n"; return 1; fi

    printf '%s' "$1" | grep -oE '\.[a-zA-Z0-9]+$'
}

