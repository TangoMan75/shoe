#!/bin/sh

## Format a ticket identifier
##
## {
##   "namespace": "git",
##   "summary": "Formats a ticket identifier to uppercase, trims whitespace, and removes special characters and spaces while preserving dashes and underscores.",
##   "requires": [
##     "tr",
##     "sed"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "TICKET",
##       "type": "str",
##       "description": "The ticket identifier to format.",
##       "default": "",
##       "nullable": false
##     }
##   ]
## }
_format_ticket() {
    echo -n "$1" | tr '[:lower:]' '[:upper:]' | tr -s ' ' | sed -E 's/[^A-Z0-9_-]//g'
}
