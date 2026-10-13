#!/bin/sh

## {
##   "namespace": "src/shell/symfony",
##   "summary": "Run test with PHPUnit",
##   "requires": [
##     "php",
##     "realpath"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info",
##     "src/shell/symfony/_phpunit"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "FILE_PATH",
##       "type": "file",
##       "description": "The path to the input file."
##     }
##   ]
## }
_sf_test() {
    if [ $# -gt 1 ]; then _echo_error "_sf_tests: too many arguments ($#)\n"; return 1; fi

    if [ -z "$1" ]; then
        _echo_info "php -d memory-limit=-1 \"$(_phpunit)\" --stop-on-failure\n"
        php -d memory-limit=-1 "$(_phpunit)" --stop-on-failure

        return 0
    fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then _echo_error "_sf_tests: \"$1\" file not found\n"; return 1; fi

    _echo_info "php -d memory-limit=-1 \"$(_phpunit)\" --stop-on-failure --testdox \"$1\"\n"
    php -d memory-limit=-1 "$(_phpunit)" --stop-on-failure --testdox "$1"
}

