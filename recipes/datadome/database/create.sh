#!/bin/sh

## Create database
##
## @namespace recipes/datadome/database
## @depends src/shell/symfony/_db_create.sh
## @assumes env
create() {
    _db_create "${env}"
}

