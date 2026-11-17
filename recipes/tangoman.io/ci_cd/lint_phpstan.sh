#!/bin/sh

## Run code analysis with PHPStan
##
## @namespace recipes/tangoman.io/ci_cd
## @requires php
## @depends src/shell/colors/_echo_info
lint_phpstan() {
    _echo_info 'php -d memory-limit=-1 ./vendor/bin/phpstan analyse -l 0 ./src ./tests\n'
    php -d memory-limit=-1 ./vendor/bin/phpstan analyse -l 0 ./src ./tests
}

