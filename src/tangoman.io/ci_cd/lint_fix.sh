#!/bin/sh

## Run linter (php-cs-fixer fix)
lint_fix() {
    # PHP CS Fixer https://cs.symfony.com/doc/usage.html
    echo_info 'php -d memory-limit=-1 ./vendor/bin/php-cs-fixer fix --allow-risky=yes --verbose --show-progress=dots\n'
    php -d memory-limit=-1 ./vendor/bin/php-cs-fixer fix --allow-risky=yes --verbose --show-progress=dots
}

