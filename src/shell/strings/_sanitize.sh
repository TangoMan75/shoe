#!/bin/sh

## Sanitize string for safe eval
##
## Sanitizes a string for safe eval by escaping every character the shell
## would otherwise interpret: backslash, dollar sign, backtick and double
## quote. Newlines are replaced with spaces so an escaped value always
## stays on a single line.
##
## @namespace src/shell/strings
## @requires printf sed tr
## @param {str} <STRING> (required) The string to sanitize.
_sanitize() {
    # The backslash is escaped first: escaping it after the other
    # characters would double the backslashes those escapes introduce.
    # shellcheck disable=SC2016
    printf '%s' "$1" \
        | sed -e 's/\\/\\\\/g' -e 's/\$/\\$/g' -e 's/`/\\`/g' \
            -e 's/"/\\"/g' \
        | tr '\n' ' '
}

