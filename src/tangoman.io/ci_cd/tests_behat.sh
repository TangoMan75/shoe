#!/bin/sh

## Run behat tests
tests_behat() {
    # force test environment
    env='test'
    composer_install

    echo_info "php -d memory-limit=-1 ./vendor/bin/behat --format=progress\n"
    php -d memory-limit=-1 ./vendor/bin/behat --format=progress

}

