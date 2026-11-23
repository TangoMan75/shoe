#!/bin/sh

## Decode a base64 string
##
## @namespace src/shell/strings
## @requires base64 command printf
## @depends src/shell/colors/_echo_error.sh
## @param {str} <STRING> (required) The base64 string to decode.
_decode_base64() {
    if [ -z "$1" ]; then _echo_error '_decode_base64: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_decode_base64: too many arguments ($#)\n"; return 1; fi

    if ! command -v base64 >/dev/null 2>&1; then
        _echo_error '_decode_base64: base64 required\n'

        return 1
    fi

    printf '%s' "$1" | base64 --decode
}

