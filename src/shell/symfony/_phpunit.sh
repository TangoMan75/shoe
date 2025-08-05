#!/bin/sh

# Get correct PHPUnit binary path
#
# {
#   "namespace": "ci_cd",
#   "depends": [
#     "echo_danger"
#   ]
# }
_phpunit() {
    if [ -f ./vendor/bin/phpunit ]; then
        echo ./vendor/bin/phpunit

        return 0
    fi

    if [ -f ./vendor/bin/simple-phpunit ]; then
        echo ./vendor/bin/simple-phpunit

        return 0
    fi

    if [ -f ./vendor/symfony/phpunit-bridge/bin/simple-phpunit ]; then
        echo './vendor/symfony/phpunit-bridge/bin/simple-phpunit'

        return 0
    fi

    if [ -f ./bin/phpunit ]; then
        echo './bin/phpunit'

        return 0
    fi

    echo_danger "error: \"$(basename "${0}")\" requires phpunit, try: 'composer install'\n"

    return 1
}

