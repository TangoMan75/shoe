#!/bin/sh

## Create database
##
## @namespace recipes/datadome/database
## @depends src/shell/symfony/_db_create
## @assumes env
create() {
    _db_create "${env}"
}

