#!/bin/sh

## Run tests
##
## @namespace recipes/rick_and_morty/ci_cd
## @depends recipes/rick_and_morty/ci_cd/tests_functional.sh
## @depends recipes/rick_and_morty/ci_cd/tests_integration.sh
## @depends recipes/rick_and_morty/ci_cd/tests_unit.sh
## @depends recipes/rick_and_morty/database/reset_db.sh
## @depends src/shell/symfony/_composer_install.sh
tests() {
    _composer_install

    tests_unit
    reset_db

    tests_integration

    reset_db
    tests_functional
}

