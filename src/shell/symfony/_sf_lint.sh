#!/bin/sh

## {
##   "namespace": "src/shell/symfony",
##   "summary": "Run linter (sniff)",
##   "requires": [
##     "composer",
##     "find",
##     "php"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/symfony/_console",
##     "src/shell/system/_check_installed"
##   ]
## }
_sf_lint() {
    _check_installed php
    _check_installed composer

    # check composer validity
    _echo_info 'composer validate\n'
    composer validate

    # check php files syntax
    _echo_info "php -l -d memory-limit=-1 -d display_errors=0 \"...\"\n"
    find ./src ./tests -type f -name '*.php' | while read -r __file__; do
        php -l -d memory-limit=-1 -d display_errors=0 "${__file__}"
    done

    _echo_info "$(_console) lint:container\n"
    $(_console) lint:container

    _echo_info "$(_console) lint:twig ./templates --show-deprecations\n"
    $(_console) lint:twig ./templates --show-deprecations

    _echo_info "$(_console) lint:yaml ./compose.yaml ./compose.*.yaml"
    $(_console) lint:yaml ./compose.yaml ./compose.*.yaml
}

