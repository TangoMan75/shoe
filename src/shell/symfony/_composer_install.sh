#!/bin/sh

## Install project dependencies with composer
##
## @namespace src/shell/symfony
## @requires composer install
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/system/_check_installed.sh
## @depends src/shell/system/_pwd.sh
_composer_install() {
    _check_installed composer

    _echo_info "composer install --no-interaction --prefer-dist --optimize-autoloader --working-dir=\"$(_pwd)\"\n"
    composer install --no-interaction --prefer-dist --optimize-autoloader --working-dir="$(_pwd)"
}

