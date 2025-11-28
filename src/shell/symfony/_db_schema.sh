#!/bin/sh

## Create schema with Doctrine
##
## {
##   "namespace": "symfony",
##   "depends": [
##     "_console",
##     "_echo_error",
##     "_echo_info"
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
_db_schema() {
    if [ -z "$1" ]; then _echo_error '_db_create: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_db_create: too many arguments ($#)\n"; return 1; fi

    _echo_info "$(_console) doctrine:schema:create --dump-sql --env \"$1\"\n"
    $(_console) doctrine:schema:create --dump-sql --env "$1"

    # following command will not break script execution on failure even with `-e` option enabled
    _echo_info "$(_console) doctrine:schema:create --env \"$1\" || true\n"
    $(_console) doctrine:schema:create --env "$1" || true
}

