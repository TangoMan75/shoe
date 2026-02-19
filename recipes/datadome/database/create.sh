#!/bin/sh

## Create database
##
## {
##   "namespace": "database",
##   "depends": [
##     "_db_create"
##   ],
##   "assumes": [
##     "env"
##   ]
## }
create() {
    _db_create "${env}"
}

