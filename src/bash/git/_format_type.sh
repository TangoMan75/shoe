#!/bin/sh

## Format a conventional commit type
##
## {
##   "namespace": "git",
##   "summary": "Formats a conventional commit type to lowercase, trims whitespace, replaces special characters and spaces with underscores, and removes trailing underscores.",
##   "requires": [
##     "tr",
##     "sed"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "TYPE",
##       "type": "str",
##       "description": "The commit type to format.",
##       "default": "",
##       "nullable": false
##     }
##   ]
## }
_format_type() {
    echo -n "$1" | tr '[:upper:]' '[:lower:]' | tr -s ' ' | sed -E 's/[^a-z0-9_-]/_/g' | sed -E 's/_+$//'
}
