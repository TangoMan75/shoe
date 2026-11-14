#!/bin/sh

## Clear Symfony cache
##
## @namespace src/shell/symfony
## @requires clear
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/symfony/_console
## @param {str} <ENV> /^(dev|prod|test)$/ Environment.
_sf_cache() {
    if [ -z "$1" ]; then _echo_error '_sf_cache: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_sf_cache: too many arguments ($#)\n"; return 1; fi

    _echo_info "$(_console) cache:clear --env \"$1\"\n"
    $(_console) cache:clear --env "$1"

    _echo_info "$(_console) cache:warmup --env \"$1\"\n"
    $(_console) cache:warmup --env "$1"
}

