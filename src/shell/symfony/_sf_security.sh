#!/bin/sh

## Check security issues in project dependencies (symfony-cli)
##
## @namespace src/shell/symfony
## @requires composer symfony
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/system/_is_installed
_sf_security() {
    if _is_installed symfony; then
        _echo_info 'symfony security:check\n'
        symfony security:check

        return 0
    fi

    if _is_installed composer; then
        _echo_info 'composer audit\n'
        composer audit

        return 0
    fi

    _echo_error "\"$0\" requires symfony or composer.\n"
    return 1
}

