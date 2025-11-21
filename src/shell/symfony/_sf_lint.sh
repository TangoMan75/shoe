#!/bin/sh

# Run linter (sniff)
#
# {
#   "namespace": "symfony",
#   "requires": [
#     "composer",
#     "php"
#   ],
#   "depends": [
#     "_check_installed",
#     "_console",
#     "echo_info"
#   ]
# }
_sf_lint() {
    _check_installed php
    _check_installed composer

    # check composer validity
    echo_info 'composer validate\n'
    composer validate

    # check php files syntax
    echo_info "php -l -d memory-limit=-1 -d display_errors=0 \"...\"\n"
    find ./src ./tests -type f -name '*.php' | while read -r __file__; do
        php -l -d memory-limit=-1 -d display_errors=0 "${__file__}"
    done

    echo_info "$(_console) lint:container\n"
    $(_console) lint:container

    echo_info "$(_console) lint:twig ./templates --show-deprecations\n"
    $(_console) lint:twig ./templates --show-deprecations

    echo_info "$(_console) lint:yaml ./compose.yaml ./compose.*.yaml"
    $(_console) lint:yaml ./compose.yaml ./compose.*.yaml
}

