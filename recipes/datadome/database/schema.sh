#!/bin/sh

## Create schema
##
## @namespace recipes/datadome/database
## @depends src/shell/symfony/_db_schema
## @assumes env
schema() {
    _db_schema "${env}"
}

