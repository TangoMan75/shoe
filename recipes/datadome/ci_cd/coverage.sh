#!/bin/sh

## {
##   "namespace": "recipes/datadome/ci_cd",
##   "summary": "Output test coverage (phpunit)",
##   "requires": [
##     "php"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/symfony/_phpunit"
##   ]
## }
coverage() {
    _echo_info "XDEBUG_MODE=coverage php -d memory-limit=-1 \"$(_phpunit)\" --coverage-html ./coverage\n"
    XDEBUG_MODE=coverage php -d memory-limit=-1 "$(_phpunit)" --coverage-html ./coverage
}

