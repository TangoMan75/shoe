#!/bin/sh

## Install project dependencies with composer
composer_install() {
    if [ ! -x "$(command -v composer)" ]; then
        echo_error "\"$(basename "${0}")\" requires composer\n"
        return 1
    fi

    echo_info "composer install --no-interaction --prefer-dist --optimize-autoloader --working-dir=\"$(pwd)\"\n"
    composer install --no-interaction --prefer-dist --optimize-autoloader --working-dir="$(pwd)"
}

