#!/bin/sh

## Check security issues in project dependencies (symfony-cli)
##
## {
##   "namespace": "symfony",
##   "requires": [
##     "composer",
##     "symfony"
##   ],
##   "depends": [
##     "_check_installed",
##     "_echo_error",
##     "_echo_info"
##   ]
## }
_security() {
    if "$(_is_installed symfony)"; then
        _echo_info 'symfony security:check\n'
        symfony security:check

        return 0
    fi

    if "$(_is_installed composer)"; then
        _echo_info 'composer audit\n'
        composer audit

        return 0
    fi

    _echo_error "\"$0\" requires symfony or composer.\n"
    return 1
}

