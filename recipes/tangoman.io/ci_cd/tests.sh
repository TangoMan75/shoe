#!/bin/sh

## Run tests
##
## @namespace recipes/tangoman.io/ci_cd
## @depends recipes/tangoman.io/ci_cd/check_drivers.sh
## @depends recipes/tangoman.io/ci_cd/tests_functional.sh
## @depends recipes/tangoman.io/ci_cd/tests_integration.sh
## @depends recipes/tangoman.io/ci_cd/tests_unit.sh
## @depends recipes/tangoman.io/database/create_db.sh
## @depends recipes/tangoman.io/database/drop.sh
## @depends recipes/tangoman.io/database/schema.sh
## @depends src/shell/symfony/_composer_install.sh
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

