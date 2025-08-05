#!/bin/sh

# Install project dependencies with composer
#
# {
#   "namespace": "symfony",
#   "requires": [
#     "composer"
#   ],
#   "depends": [
#     "_check_installed",
#     "_pwd",
#     "echo_info"
#   ]
# }
_composer_install() {
    _check_installed composer

    echo_info "composer install --no-interaction --prefer-dist --optimize-autoloader --working-dir=\"$(_pwd)\"\n"
    composer install --no-interaction --prefer-dist --optimize-autoloader --working-dir="$(_pwd)"
}

