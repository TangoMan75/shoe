#!/bin/sh

## Validate a file checksum
##
## @namespace src/shell/system
## @requires awk grep realpath set sha256sum
## @depends src/shell/colors/_echo_error src/shell/system/_check_installed
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <SHA256SUM> (required) A string containing file checksum.
_is_checksum_valid() {
    _check_installed sha256sum

    if [ $# -lt 2 ]; then _echo_error '_is_checksum_valid: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_is_checksum_valid: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"
    if [ ! -f "$1" ]; then _echo_error "_is_checksum_valid: \"$1\" file not found\n"; return 1; fi

    sha256sum "$1" | awk '{print $1}' | grep -q "$2"
}

