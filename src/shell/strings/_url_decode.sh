#!/bin/sh

## Decode a string from URL format
##
## Replaces every percent-encoded sequence with the matching character.
##
## @namespace src/shell/strings
## @requires awk printf
## @depends src/shell/colors/_echo_error
## @param {str} <STRING> (required) The URL-encoded string to decode.
_url_decode() {
    if [ -z "$1" ]; then _echo_error '_url_decode: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_url_decode: too many arguments ($#)\n"; return 1; fi

    printf '%s' "$1" | LC_ALL=C awk '
        function hex_value(hex,    i, digit, value) {
            value = 0
            hex = tolower(hex)
            for (i = 1; i <= 2; i++) {
                digit = index("0123456789abcdef", substr(hex, i, 1)) - 1
                value = value * 16 + digit
            }
            return value
        }
        {
            result = ""
            for (i = 1; i <= length($0); i++) {
                char = substr($0, i, 1)
                pair = substr($0, i + 1, 2)
                if (char == "%" && pair ~ /^[0-9A-Fa-f][0-9A-Fa-f]$/) {
                    result = result sprintf("%c", hex_value(pair))
                    i += 2
                } else {
                    result = result char
                }
            }
            printf "%s", result
        }'
}

