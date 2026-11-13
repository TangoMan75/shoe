#!/bin/sh

## Check security issues in project dependencies (symfony-cli)
##
## @namespace recipes/tangoman.io/ci_cd
## @requires symfony
## @depends src/shell/colors/_echo_info src/shell/system/_check_installed
security() {
    _check_installed symfony

    _echo_info 'symfony security:check\n'
    symfony security:check
}

