#!/bin/sh

## {
##   "namespace": "recipes/datadome/database",
##   "summary": "Create database",
##   "depends": [
##     "src/shell/symfony/_db_create"
##   ],
##   "assumes": [
##     "env"
##   ]
## }
create() {
    _db_create "${env}"
}

