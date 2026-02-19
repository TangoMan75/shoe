#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/ci_cd",
##   "summary": "Run functional tests",
##   "requires": [
##     "php"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/symfony/_phpunit"
##   ]
## }
tests_functional() {
    # force test environment
    env='test'

    if [ "${file}" ]; then
        _echo_info "php -d memory-limit=-1 \"$(_phpunit)\" --stop-on-failure --testdox --testdox \"${file}\"\n"
        php -d memory-limit=-1 "$(_phpunit)" --stop-on-failure --testdox --testdox "${file}"
        return 0
    fi

    _echo_info "php -d memory-limit=-1 \"$(_phpunit)\" --stop-on-failure --testdox tests/Functional\n"
    php -d memory-limit=-1 "$(_phpunit)" --stop-on-failure --testdox tests/Functional
}

