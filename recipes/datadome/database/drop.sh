#!/bin/sh

## Drop database
##
## {
##   "namespace": "database",
##   "depends": [
##     "_db_drop"
##   ],
##   "assumes": [
##     "env"
##   ]
## }
drop() {
    _db_drop "${env}"
}

