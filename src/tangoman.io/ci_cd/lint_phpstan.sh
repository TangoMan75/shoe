#!/bin/sh

## Run code analysis with PHPStan
lint_phpstan() {
    echo_info 'php -d memory-limit=-1 ./vendor/bin/phpstan analyse -l 0 ./src ./tests\n'
    php -d memory-limit=-1 ./vendor/bin/phpstan analyse -l 0 ./src ./tests
}

