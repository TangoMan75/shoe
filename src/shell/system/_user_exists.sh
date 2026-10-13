#!/bin/sh

## {
##   "namespace": "src/shell/system",
##   "summary": "Check provided user exists",
##   "requires": [
##     "id"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "USERNAME",
##       "description": "The username to check.",
##       "type": "str",
##       "required": true
##     }
##   ]
## }
_user_exists() {
    if [ -z "$1" ]; then _echo_error '_user_exists: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_user_exists: too many arguments ($#)\n"; return 1; fi

    if [ -n "$(id -u "$1" 2>/dev/null)" ]; then

        return 0
    fi

    return 1
}

