#!/bin/sh

## Squeezes repeated whitespaces and trim leading and trailing whitespaces from a string
##
## Squeezes repeated whitespaces and trim leading and trailing whitespaces from a string.
##
## @namespace src/shell/strings
## @requires printf sed tr
## @param {str} <STRING> (required) The string to trim.
_trim() {
    # tr -s, --squeeze-repeats    replace each sequence of a repeated character
    printf '%s' "$1" | tr -s ' ' | sed -e 's/^ *//' -e 's/ *$//'
}

