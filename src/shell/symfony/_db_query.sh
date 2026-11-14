#!/bin/sh

## Executes arbitrary SQL directly from the command line
##
## @namespace src/shell/symfony
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/symfony/_console
## @param {str} <SQL> /.+/ SQL query.
_db_query() {
    if [ -z "$1" ]; then _echo_error '_db_query: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_db_query: too many arguments ($#)\n"; return 1; fi

    _echo_info "$(_console) doctrine:query:sql \"$1\"\n"
    $(_console) doctrine:query:sql "$1"
}

