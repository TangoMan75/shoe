#!/bin/sh

## Encode a string to URL format
##
## @namespace src/shell/strings
## @requires awk od printf
## @depends src/shell/colors/_echo_error.sh
## @param {str} <STRING> (required) The string to URL-encode.
_url_encode() {
    if [ -z "$1" ]; then _echo_error '_url_encode: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_url_encode: too many arguments ($#)\n"; return 1; fi

    printf '%s' "$1" | od -An -v -tx1 | awk '
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
            for (i = 1; i <= NF; i++) {
                hex = tolower($i)
                value = hex_value(hex)
                if ((value >= 48 && value <= 57) \
                    || (value >= 65 && value <= 90) \
                    || (value >= 97 && value <= 122) \
                    || value == 45 || value == 46 \
                    || value == 95 || value == 126) {
                    result = result sprintf("%c", value)
                } else {
                    result = result "%" toupper(hex)
                }
            }
            printf "%s", result
        }'
}

