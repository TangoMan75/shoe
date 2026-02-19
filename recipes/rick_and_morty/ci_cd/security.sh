#!/bin/sh

## Check security issues in project dependencies (symfony-cli)
##
## {
##   "namespace": "ci_cd",
##   "requires": [
##     "symfony"
##   ],
##   "depends": [
##     "_check_installed"
##   ]
## }
security() {
    _check_installed symfony

    _echo_info 'symfony security:check\n'
    symfony security:check
}

