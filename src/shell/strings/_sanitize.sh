#!/bin/sh

## Sanitize string for safe eval
##
## Sanitizes a string for safe eval by escaping backticks.
##
## @namespace src/shell/strings
## @requires printf sed
## @param {str} <STRING> (required) The string to sanitize.
_sanitize() {
    # escape backticks to prevent command substitution
    printf '%s' "$1" | sed 's/`/\\`/g'
}

