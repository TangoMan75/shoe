#!/bin/sh

## Return correct PHPUnit binary path
_get_phpunit() {
    if [ -f ./vendor/bin/phpunit ]; then
        echo ./vendor/bin/phpunit

    elif [ -f ./vendor/bin/simple-phpunit ]; then
        echo ./vendor/bin/simple-phpunit

    elif [ -f ./vendor/symfony/phpunit-bridge/bin/simple-phpunit ]; then
        echo './vendor/symfony/phpunit-bridge/bin/simple-phpunit'

    elif [ -f ./bin/phpunit ]; then
        echo './bin/phpunit'
    fi
}

