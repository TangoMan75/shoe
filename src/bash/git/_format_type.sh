#!/bin/sh

## {
##   "namespace": "src/bash/git",
##   "summary": "Format a conventional commit type",
##   "description": "Formats a conventional commit type to lowercase, trims whitespace, replaces special characters and spaces with underscores, and removes trailing underscores.",
##   "requires": [
##     "echo",
##     "sed",
##     "tr"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "TYPE",
##       "description": "The commit type to format.",
##       "type": "str",
##       "required": true
##     }
##   ]
## }
_format_type() {
    echo -n "$1" | tr '[:upper:]' '[:lower:]' | tr -s ' ' | sed -E 's/[^a-z0-9_-]/_/g' | sed -E 's/_+$//'
}
