#!/bin/sh

## {
##   "namespace": "recipes/rick_and_morty/ci_cd",
##   "summary": "Run tests",
##   "depends": [
##     "recipes/rick_and_morty/ci_cd/tests_functional",
##     "recipes/rick_and_morty/ci_cd/tests_integration",
##     "recipes/rick_and_morty/ci_cd/tests_unit",
##     "recipes/rick_and_morty/database/reset_db",
##     "src/shell/symfony/_composer_install"
##   ]
## }
tests() {
    _composer_install

    tests_unit
    reset_db

    tests_integration

    reset_db
    tests_functional
}

