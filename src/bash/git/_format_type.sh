#!/bin/sh

## Format a conventional commit type
##
## Formats a conventional commit type to lowercase, trims whitespace, replaces special characters and spaces with underscores, and removes trailing underscores.
##
## @namespace src/bash/git
## @requires echo sed tr
## @param {str} <TYPE> (required) The commit type to format.
_format_type() {
    echo -n "$1" | tr '[:upper:]' '[:lower:]' | tr -s ' ' | sed -E 's/[^a-z0-9_-]/_/g' | sed -E 's/_+$//'
}

