#!/bin/sh

## Run unit tests
tests_unit() {
    # force test environment
    env='test'

    if [ "${file}" ]; then
        echo_info "php -d memory-limit=-1 \"$(_get_phpunit)\" --stop-on-failure --testdox \"${file}\"\n"
        php -d memory-limit=-1 "$(_get_phpunit)" --stop-on-failure --testdox "${file}"
        return 0
    fi

    echo_info "php -d memory-limit=-1 \"$(_get_phpunit)\" --stop-on-failure --testdox tests/Unit\n"
    php -d memory-limit=-1 "$(_get_phpunit)" --stop-on-failure --testdox tests/Unit

}

