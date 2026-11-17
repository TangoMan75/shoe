#!/bin/sh

## Run integration tests
##
## @namespace recipes/tangoman.io/ci_cd
## @requires php
## @depends src/shell/colors/_echo_info
## @depends src/shell/symfony/_phpunit
## @option {path} <file> /^~?[a-zA-Z0-9./_-]+$/ File to test.
tests_integration() {
    # force test environment
    env='test'

    if [ "${file}" ]; then
        _echo_info "php -d memory-limit=-1 \"$(_phpunit)\" --stop-on-failure --testdox --testdox \"${file}\"\n"
        php -d memory-limit=-1 "$(_phpunit)" --stop-on-failure --testdox --testdox "${file}"
        return 0
    fi

    _echo_info "php -d memory-limit=-1 \"$(_phpunit)\" --stop-on-failure --testdox tests/Integration\n"
    php -d memory-limit=-1 "$(_phpunit)" --stop-on-failure --testdox tests/Integration
}

