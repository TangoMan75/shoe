#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/ci_cd",
##   "summary": "Run tests",
##   "depends": [
##     "recipes/datadome/database/drop",
##     "recipes/datadome/database/schema",
##     "recipes/rick_and_morty/ci_cd/tests_functional",
##     "recipes/rick_and_morty/ci_cd/tests_integration",
##     "recipes/rick_and_morty/ci_cd/tests_unit",
##     "recipes/rick_and_morty/doctrine/create_db",
##     "recipes/tangoman.io/ci_cd/check_drivers",
##     "src/shell/symfony/_composer_install"
##   ]
## }
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
