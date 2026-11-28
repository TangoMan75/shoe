#!/bin/sh

## Drop database
##
## @namespace recipes/datadome/database
## @depends src/shell/symfony/_db_drop.sh
## @assumes env
drop() {
    _db_drop "${env}"
}

