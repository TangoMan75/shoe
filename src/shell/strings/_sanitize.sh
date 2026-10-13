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
##   "params": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "description": "The string to sanitize.",
##       "type": "str",
##       "required": true
##     }
##   ]
## }
_sanitize() {
    # escape backticks to prevent command substitution
    printf '%s' "$1" | sed 's/`/\\`/g'
}
