#!/bin/sh

## Format a ticket identifier
##
## Formats a ticket identifier to uppercase, trims whitespace, and removes special characters and spaces while preserving dashes and underscores.
##
## @namespace src/bash/git
## @requires echo sed tr
## @param {str} <TICKET> (required) The ticket identifier to format.
_format_ticket() {
    echo -n "$1" | tr '[:lower:]' '[:upper:]' | tr -s ' ' | sed -E 's/[^A-Z0-9_-]//g'
}

