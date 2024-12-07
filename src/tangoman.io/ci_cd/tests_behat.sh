#!/bin/sh

## Run behat tests
tests_behat() {
    # force test environment
    env='test'

    echo_info "php -d memory-limit=-1 ./vendor/bin/behat --format=progress\n"
    php -d memory-limit=-1 ./vendor/bin/behat --format=progress

}

