#!/bin/sh

## Format a conventional commit type
##
## Formats a conventional commit type to lowercase, trims whitespace,
## replaces special characters and spaces with underscores, and removes
## trailing underscores.
##
## @namespace src/shell/git
## @requires printf sed tr
## @param {str} <TYPE> (required) The commit type to format.
_format_type() {
    printf '%s' "$1" \
        | tr '[:upper:]' '[:lower:]' \
        | tr -s ' ' \
        | sed -e 's/[^a-z0-9_-]/_/g' \
        | sed -e 's/_\{1,\}$//'
}

