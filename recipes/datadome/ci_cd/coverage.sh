#!/bin/sh

## Output test coverage (phpunit)
##
## @namespace recipes/datadome/ci_cd
## @requires php
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/symfony/_phpunit.sh
coverage() {
    _echo_info "XDEBUG_MODE=coverage php -d memory-limit=-1 \"$(_phpunit)\" --coverage-html ./coverage\n"
    XDEBUG_MODE=coverage php -d memory-limit=-1 "$(_phpunit)" --coverage-html ./coverage
}

