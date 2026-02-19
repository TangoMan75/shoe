#!/bin/sh

## {
##   "namespace": "recipes/datadome/database",
##   "summary": "Reset Symfony database",
##   "depends": [
##     "src/shell/symfony/_db_create",
##     "src/shell/symfony/_db_drop",
##     "src/shell/symfony/_db_schema",
##     "src/shell/symfony/_sf_cache"
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

