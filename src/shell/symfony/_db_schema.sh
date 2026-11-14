#!/bin/sh

## Create schema with Doctrine
##
## @namespace src/shell/symfony
## @requires true
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/symfony/_console
## @param {str} <ENV> /^(dev|prod|test)$/ Environment.
_db_schema() {
    if [ -z "$1" ]; then _echo_error '_db_create: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_db_create: too many arguments ($#)\n"; return 1; fi

    _echo_info "$(_console) doctrine:schema:create --dump-sql --env \"$1\"\n"
    $(_console) doctrine:schema:create --dump-sql --env "$1"

    # following command will not break script execution on failure even with `-e` option enabled
    _echo_info "$(_console) doctrine:schema:create --env \"$1\" || true\n"
    $(_console) doctrine:schema:create --env "$1" || true
}

