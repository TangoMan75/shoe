#!/bin/sh

## Create schema
##
## {
##   "namespace": "database",
##   "depends": [
##     "_db_schema"
##   ],
##   "assumes": [
##     "env"
##   ]
## }
schema() {
    _db_schema "${env}"
}

