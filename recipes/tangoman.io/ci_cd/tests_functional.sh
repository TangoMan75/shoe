#!/bin/sh

## Run functional tests
##
## @namespace recipes/tangoman.io/ci_cd
## @requires php
## @depends src/shell/colors/_echo_info src/shell/symfony/_phpunit
## @assumes file
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

