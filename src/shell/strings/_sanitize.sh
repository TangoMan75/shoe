#!/bin/sh

## Sanitize string for safe eval
##
## {
##   "namespace": "src/shell/strings",
##   "summary": "Sanitizes a string for safe eval by escaping backticks.",
##   "requires": [
##     "printf",
##     "sed"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "The string to sanitize.",
##       "nullable": false
##     }
##   ]
## }
_sanitize() {
    # escape backticks to prevent command substitution
    printf '%s' "$1" | sed 's/`/\\`/g'
}
