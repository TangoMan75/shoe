#!/bin/sh

## {
##   "namespace": "src/shell/symfony",
##   "summary": "Create Symfony database with Doctrine",
##   "requires": [
##     "true"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info",
##     "src/shell/symfony/_console"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "ENV",
##       "type": "str",
##       "description": "Environment.",
##       "constraint": "/^(dev|prod|test)$/"
##     }
##   ]
## }
_db_create() {
    if [ -z "$1" ]; then _echo_error '_db_create: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_db_create: too many arguments ($#)\n"; return 1; fi

    # following command will not break script execution on failure even with `-e` option enabled
    _echo_info "$(_console) doctrine:database:create --env \"$1\" || true\n"
    $(_console) doctrine:database:create --env "$1" || true
}

