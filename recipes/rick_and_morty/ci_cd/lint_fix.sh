#!/bin/sh

## Run linter (php-cs-fixer fix)
##
## {
##   "namespace": "ci_cd",
##   "requires": [
##     "php"
##   ],
##   "depends": [
##     "_echo_info"
##   ]
## }
lint_fix() {
    # PHP CS Fixer https://cs.symfony.com/doc/usage.html
    _echo_info 'php -d memory-limit=-1 ./vendor/bin/php-cs-fixer fix --allow-risky=yes --verbose --show-progress=dots\n'
    php -d memory-limit=-1 ./vendor/bin/php-cs-fixer fix --allow-risky=yes --verbose --show-progress=dots
}

