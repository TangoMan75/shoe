#!/bin/sh

## {
##   "namespace": "src/shell/shoedoc",
##   "summary": "Get shoedoc annotation",
##   "description": "Removes every line that does not start with a pound character or contains a tag\nReturns string without leading pound characters",
##   "requires": [
##     "awk",
##     "printf"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "TEXT",
##       "description": "The input shoedoc annotation bloc.",
##       "type": "str",
##       "required": true
##     }
##   ]
## }
_get_shoedoc() {
    if [ -z "$1" ]; then _echo_error '_get_shoedoc: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_shoedoc: too many arguments ($#)\n"; return 1; fi

    printf '%s' "$1" | awk '/^## .*/ {
        if (substr($2,1,1) != "@") {
            RESULT=substr($0,length($1)+2); # remove leading pound character(s)
            print RESULT
        }
    }'
}

