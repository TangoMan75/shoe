#!/bin/sh

## Install project dependencies with composer
composer_install() {
    echo_info "composer install --no-interaction --prefer-dist --optimize-autoloader --working-dir=\"$(pwd)\"\n"
    composer install --no-interaction --prefer-dist --optimize-autoloader --working-dir="$(pwd)"
}

