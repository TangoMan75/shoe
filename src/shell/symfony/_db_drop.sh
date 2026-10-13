#!/bin/sh

## {
##   "namespace": "src/shell/symfony",
##   "summary": "Drop database with Doctrine",
##   "requires": [
##     "true"
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
_db_drop() {
    if [ -z "$1" ]; then _echo_error '_db_drop: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_db_drop: too many arguments ($#)\n"; return 1; fi

    # following command will not break script execution on failure even with `-e` option enabled
    _echo_info "$(_console) doctrine:database:drop --force --env \"$1\" || true\n"
    $(_console) doctrine:database:drop --force --env "$1" || true
}

