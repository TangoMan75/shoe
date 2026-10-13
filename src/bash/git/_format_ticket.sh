#!/bin/sh

## {
##   "namespace": "src/bash/git",
##   "summary": "Format a ticket identifier",
##   "description": "Formats a ticket identifier to uppercase, trims whitespace, and removes special characters and spaces while preserving dashes and underscores.",
##   "requires": [
##     "echo",
##     "sed",
##     "tr"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "TICKET",
##       "description": "The ticket identifier to format.",
##       "type": "str",
##       "required": true
##     }
##   ]
## }
_format_ticket() {
    echo -n "$1" | tr '[:lower:]' '[:upper:]' | tr -s ' ' | sed -E 's/[^A-Z0-9_-]//g'
}
