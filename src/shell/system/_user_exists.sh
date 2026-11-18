#!/bin/sh

## Check provided user exists
##
## @namespace src/shell/system
## @requires id
## @depends src/shell/colors/_echo_error
## @param {str} <USERNAME> (required) The username to check.
_user_exists() {
    if [ -z "$1" ]; then _echo_error '_user_exists: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_user_exists: too many arguments ($#)\n"; return 1; fi

    if [ -n "$(id -u "$1" 2>/dev/null)" ]; then

        return 0
    fi

    return 1
}

