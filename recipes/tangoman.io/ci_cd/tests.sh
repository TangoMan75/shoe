#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/ci_cd",
##   "summary": "Run tests",
##   "depends": [
##     "recipes/tangoman.io/ci_cd/check_drivers",
##     "recipes/tangoman.io/ci_cd/tests_functional",
##     "recipes/tangoman.io/ci_cd/tests_integration",
##     "recipes/tangoman.io/ci_cd/tests_unit",
##     "recipes/tangoman.io/database/create_db",
##     "recipes/tangoman.io/database/drop",
##     "recipes/tangoman.io/database/schema",
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

