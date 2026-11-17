#!/bin/sh

## Run tests
##
## @namespace recipes/rick_and_morty/ci_cd
## @depends recipes/rick_and_morty/ci_cd/tests_functional
## @depends recipes/rick_and_morty/ci_cd/tests_integration
## @depends recipes/rick_and_morty/ci_cd/tests_unit
## @depends recipes/rick_and_morty/database/reset_db
## @depends src/shell/symfony/_composer_install
tests() {
    _composer_install

    tests_unit
    reset_db

    tests_integration

    reset_db
    tests_functional
}

