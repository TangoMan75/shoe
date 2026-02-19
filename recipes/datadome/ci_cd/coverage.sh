#!/bin/sh

## Output test coverage (phpunit)
##
## {
##   "namespace": "ci_cd",
##   "requires": [
##     "php"
##   ],
##   "depends": [
##     "_echo_info",
##     "_phpunit"
##   ]
## }
coverage() {
    _echo_info "XDEBUG_MODE=coverage php -d memory-limit=-1 \"$(_phpunit)\" --coverage-html ./coverage\n"
    XDEBUG_MODE=coverage php -d memory-limit=-1 "$(_phpunit)" --coverage-html ./coverage
}

