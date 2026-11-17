#!/bin/sh

## Run tests
##
## @namespace recipes/tangoman.io/ci_cd
## @depends recipes/tangoman.io/ci_cd/check_drivers
## @depends recipes/tangoman.io/ci_cd/tests_functional
## @depends recipes/tangoman.io/ci_cd/tests_integration
## @depends recipes/tangoman.io/ci_cd/tests_unit
## @depends recipes/tangoman.io/database/create_db
## @depends recipes/tangoman.io/database/drop
## @depends recipes/tangoman.io/database/schema
## @depends src/shell/symfony/_composer_install
tests() {
    _composer_install

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

