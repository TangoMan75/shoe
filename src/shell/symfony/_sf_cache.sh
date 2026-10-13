#!/bin/sh

## {
##   "namespace": "src/shell/symfony",
##   "summary": "Clear Symfony cache",
##   "requires": [
##     "clear"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info",
##     "src/shell/symfony/_console"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "ENV",
##       "description": "Environment.",
##       "type": "str",
##       "constraint": "/^(dev|prod|test)$/"
##     }
##   ]
## }
_sf_cache() {
    if [ -z "$1" ]; then _echo_error '_sf_cache: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_sf_cache: too many arguments ($#)\n"; return 1; fi

    _echo_info "$(_console) cache:clear --env \"$1\"\n"
    $(_console) cache:clear --env "$1"

    _echo_info "$(_console) cache:warmup --env \"$1\"\n"
    $(_console) cache:warmup --env "$1"
}

