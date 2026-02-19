#!/bin/sh

## Run unit tests
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

