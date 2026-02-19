#!/bin/sh

## Run linter (sniff)
##
## {
##   "namespace": "ci_cd",
##   "requires": [
##     "php"
##   ],
##   "depends": [
##     "_alert_secondary",
##     "_echo_info"
##   ]
## }
lint() {
    _alert_secondary 'check composer validity'
    _echo_info 'composer validate\n'
    composer validate

    _alert_secondary 'check local requirements'
    _echo_info "./vendor/bin/requirements-checker\n"
    ./vendor/bin/requirements-checker

    _alert_secondary 'check php files syntax'
    _echo_info "php -l -d memory-limit=-1 -d display_errors=0 \"...\"\n"
    find ./src ./tests -type f -name '*.php' | while read -r FILE; do
        php -l -d memory-limit=-1 -d display_errors=0 "${FILE}"
    done

    _alert_secondary 'PHP CS Fixer'
    # PHP CS Fixer https://cs.symfony.com/doc/usage.html
    _echo_info './vendor/bin/php-cs-fixer fix --dry-run --diff --allow-risky=yes --verbose --show-progress=dots\n'
    ./vendor/bin/php-cs-fixer fix --dry-run --diff --allow-risky=yes --verbose --show-progress=dots

    _alert_secondary 'Console Lint Container'
    _echo_info "./bin/console lint:container\n"
    ./bin/console lint:container

    if [ -d ./templates ]; then
        _alert_secondary 'Console Lint Twig'
        _echo_info "./bin/console lint:twig ./templates --show-deprecations\n"
        ./bin/console lint:twig ./templates --show-deprecations
    fi

    _alert_secondary 'Console Lint Yaml'
    _echo_info "./bin/console lint:yaml ./config\n"
    ./bin/console lint:yaml ./config

    if [ -d ./fixtures ]; then
        _alert_secondary 'Console Lint Yaml'
        _echo_info "./bin/console lint:yaml ./fixtures\n"
        ./bin/console lint:yaml ./fixtures
    fi
}

