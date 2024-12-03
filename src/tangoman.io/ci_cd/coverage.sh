#!/bin/sh

## Output test coverage (phpunit)
coverage() {
    echo_info 'XDEBUG_MODE=coverage php -d memory-limit=-1 ./vendor/bin/phpunit --coverage-html ./coverage\n'
    XDEBUG_MODE=coverage php -d memory-limit=-1 ./vendor/bin/phpunit --coverage-html ./coverage
}

