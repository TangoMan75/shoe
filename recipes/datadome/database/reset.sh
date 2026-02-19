#!/bin/sh

## Reset Symfony database
##
## {
##   "namespace": "database",
##   "depends": [
##     "_db_drop",
##     "_db_create",
##     "_db_schema",
##     "_sf_cache"
##   ],
##   "assumes": [
##     "env"
##   ]
## }
reset() {
    _db_drop "${env}"
    _db_create "${env}"
    _db_schema "${env}"
    _sf_cache "${env}"
}

