#!/bin/sh

## {
##   "namespace": "recipes/datadome/database",
##   "summary": "Create schema",
##   "depends": [
##     "src/shell/symfony/_db_schema"
##   ],
##   "assumes": [
##     "env"
##   ]
## }
schema() {
    _db_schema "${env}"
}

