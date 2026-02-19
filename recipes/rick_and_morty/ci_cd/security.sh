#!/bin/sh

## {
##   "namespace": "recipes/rick_and_morty/ci_cd",
##   "summary": "Check security issues in project dependencies (symfony-cli)",
##   "requires": [
##     "symfony"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_check_installed"
##   ]
## }
security() {
    _check_installed symfony

    _echo_info 'symfony security:check\n'
    symfony security:check
}

