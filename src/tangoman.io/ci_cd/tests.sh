#!/bin/sh

## Run tests
tests() {
    composer_install

    tests_unit

    drop
    create_db
    schema
    tests_integration

    check_drivers

    drop
    create_db
    schema
    tests_functional
}

