#!/bin/sh

## Run unit tests
##
## @namespace recipes/tangoman.io/ci_cd
## @requires php
## @depends src/shell/colors/_echo_info
## @depends src/shell/symfony/_phpunit
## @option {path} <file> /^~?[a-zA-Z0-9./_-]+$/ File to test.
tests_unit() {
    # force test environment
    env='test'

    if [ "${file}" ]; then
        _echo_info "php -d memory-limit=-1 \"$(_phpunit)\" --stop-on-failure --testdox \"${file}\"\n"
        php -d memory-limit=-1 "$(_phpunit)" --stop-on-failure --testdox "${file}"
        return 0
    fi

    _echo_info "php -d memory-limit=-1 \"$(_phpunit)\" --stop-on-failure --testdox tests/Unit\n"
    php -d memory-limit=-1 "$(_phpunit)" --stop-on-failure --testdox tests/Unit

}

