#!/bin/sh

## Run integration tests
tests_integration() {
    # force test environment
    env='test'

    if [ "${file}" ]; then
        echo_info "php -d memory-limit=-1 \"$(_get_phpunit)\" --stop-on-failure --testdox --testdox \"${file}\"\n"
        php -d memory-limit=-1 "$(_get_phpunit)" --stop-on-failure --testdox --testdox "${file}"
        return 0
    fi

    echo_info "php -d memory-limit=-1 \"$(_get_phpunit)\" --stop-on-failure --testdox tests/Integration\n"
    php -d memory-limit=-1 "$(_get_phpunit)" --stop-on-failure --testdox tests/Integration
}

