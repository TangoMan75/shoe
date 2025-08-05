#!/bin/sh

# Update project dependencies with composer
#
# {
#   "namespace": "symfony",
#   "requires": [
#     "composer"
#   ],
#   "depends": [
#     "_check_installed",
#     "echo_info"
#   ]
# }
_composer_update() {
    _check_installed composer

    echo_info "composer update --with-dependencies\n"
    composer update --with-dependencies
}

