#!/bin/sh

## Squeezes repeated whitespaces and trim leading and trailing whitespaces from a string
##
## {
##   "namespace": "strings",
##   "summary": "Squeezes repeated whitespaces and trim leading and trailing whitespaces from a string.",
##   "requires": [
##     "printf",
##     "sed",
##     "tr"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "The string to trim.",
##       "nullable": false
##     }
##   ]
## }
_trim() {
    # tr -s, --squeeze-repeats    replace each sequence of a repeated character
    printf '%s' "$1" | tr -s ' ' | sed 's/^ \+//' | sed 's/ \+$//'
}

