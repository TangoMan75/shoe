#!/bin/sh

## Squeezes repeated whitespaces and trim leading and trailing whitespaces from a string
##
## {
##   "namespace": "src/shell/strings",
##   "summary": "Squeezes repeated whitespaces and trim leading and trailing whitespaces from a string.",
##   "requires": [
##     "printf",
##     "sed",
##     "tr"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "description": "The string to trim.",
##       "type": "str",
##       "required": true
##     }
##   ]
## }
_trim() {
    # tr -s, --squeeze-repeats    replace each sequence of a repeated character
    printf '%s' "$1" | tr -s ' ' | sed 's/^ \+//' | sed 's/ \+$//'
}

