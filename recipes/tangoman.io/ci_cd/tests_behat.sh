#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/ci_cd",
##   "summary": "Run behat tests",
##   "requires": [
##     "php"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
tests_behat() {
    # force test environment
    env='test'

    _echo_info "php -d memory-limit=-1 ./vendor/bin/behat --format=progress\n"
    php -d memory-limit=-1 ./vendor/bin/behat --format=progress
}

