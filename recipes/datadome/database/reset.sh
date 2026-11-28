#!/bin/sh

## Reset Symfony database
##
## @namespace recipes/datadome/database
## @depends src/shell/symfony/_db_create.sh
## @depends src/shell/symfony/_db_drop.sh
## @depends src/shell/symfony/_db_schema.sh
## @depends src/shell/symfony/_sf_cache.sh
## @assumes env
reset() {
    _db_drop "${env}"
    _db_create "${env}"
    _db_schema "${env}"
    _sf_cache "${env}"
}

