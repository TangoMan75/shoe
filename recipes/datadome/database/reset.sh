#!/bin/sh

## Reset Symfony database
##
## @namespace recipes/datadome/database
## @depends src/shell/symfony/_db_create
## @depends src/shell/symfony/_db_drop
## @depends src/shell/symfony/_db_schema
## @depends src/shell/symfony/_sf_cache
## @assumes env
reset() {
    _db_drop "${env}"
    _db_create "${env}"
    _db_schema "${env}"
    _sf_cache "${env}"
}

