#!/bin/sh

## {
##   "namespace": "recipes/datadome/database",
##   "summary": "Executes arbitrary SQL directly from the command line",
##   "depends": [
##     "src/shell/symfony/_db_query"
##   ],
##   "assumes": [
##     "sql"
##   ]
## }
query() {
    _db_query "${sql}"
}

