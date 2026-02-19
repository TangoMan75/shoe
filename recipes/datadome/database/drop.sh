#!/bin/sh

## {
##   "namespace": "recipes/datadome/database",
##   "summary": "Drop database",
##   "depends": [
##     "src/shell/symfony/_db_drop"
##   ],
##   "assumes": [
##     "env"
##   ]
## }
drop() {
    _db_drop "${env}"
}

