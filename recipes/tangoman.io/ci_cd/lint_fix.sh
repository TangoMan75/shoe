#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/ci_cd",
##   "summary": "Run linter (php-cs-fixer fix)",
##   "requires": [
##     "php",
##     "yes"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
lint_fix() {
    # PHP CS Fixer https://cs.symfony.com/doc/usage.html
    _echo_info 'php -d memory-limit=-1 ./vendor/bin/php-cs-fixer fix --allow-risky=yes --verbose --show-progress=dots\n'
    php -d memory-limit=-1 ./vendor/bin/php-cs-fixer fix --allow-risky=yes --verbose --show-progress=dots
}

