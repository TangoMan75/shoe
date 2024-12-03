#!/bin/sh

## Run linter (sniff)
lint() {
    # check composer validity
    echo_info 'composer validate\n'
    composer validate

    # check local requirements
    echo_info "./vendor/bin/requirements-checker\n"
    ./vendor/bin/requirements-checker

    # check php files syntax
    echo_info "php -l -d memory-limit=-1 -d display_errors=0 \"...\"\n"
    find ./src ./tests -type f -name '*.php' | while read -r FILE; do
        # echo_info "php -l -d memory-limit=-1 -d display_errors=0 \"${FILE}\"\n"
        php -l -d memory-limit=-1 -d display_errors=0 "${FILE}"
    done

    # PHP CS Fixer https://cs.symfony.com/doc/usage.html
    echo_info './vendor/bin/php-cs-fixer fix --dry-run --diff --allow-risky=yes --verbose --show-progress=dots\n'
    ./vendor/bin/php-cs-fixer fix --dry-run --diff --allow-risky=yes --verbose --show-progress=dots

    # # squizlabs/php_codesniffer https://github.com/squizlabs/PHP_CodeSniffer
    # echo_info "./vendor/bin/phpcs\n"
    # ./vendor/bin/phpcs

    echo_info "./bin/console lint:container\n"
    ./bin/console lint:container

    echo_info "./bin/console lint:twig ./templates --show-deprecations\n"
    ./bin/console lint:twig ./templates --show-deprecations

    echo_info "./bin/console lint:yaml ./config\n"
    ./bin/console lint:yaml ./config

    echo_info "./bin/console lint:yaml ./fixtures\n"
    ./bin/console lint:yaml ./fixtures
}

