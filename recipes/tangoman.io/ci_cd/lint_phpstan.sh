#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/ci_cd",
##   "summary": "Run code analysis with PHPStan",
##   "requires": [
##     "php"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
lint_phpstan() {
    _echo_info 'php -d memory-limit=-1 ./vendor/bin/phpstan analyse -l 0 ./src ./tests\n'
    php -d memory-limit=-1 ./vendor/bin/phpstan analyse -l 0 ./src ./tests
}

