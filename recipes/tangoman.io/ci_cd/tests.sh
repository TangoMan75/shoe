#!/bin/sh

## Run tests
##
## {
##   "namespace": "ci_cd",
##   "depends": [
##     "_composer_install",
##     "check_drivers",
##     "create_db",
##     "drop",
##     "schema",
##     "tests_functional",
##     "tests_integration",
##     "tests_unit"
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
