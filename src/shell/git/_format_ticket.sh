#!/bin/sh

## Format a ticket identifier
##
## Formats a ticket identifier to uppercase, trims whitespace, and
## removes special characters and spaces while preserving dashes and
## underscores.
##
## @namespace src/shell/git
## @requires printf sed tr
## @param {str} <TICKET> (required) The ticket identifier to format.
_format_ticket() {
    printf '%s' "$1" \
        | tr '[:lower:]' '[:upper:]' \
        | tr -s ' ' \
        | sed -e 's/[^A-Z0-9_-]//g'
}

