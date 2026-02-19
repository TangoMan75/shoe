#!/bin/sh

## Executes arbitrary SQL directly from the command line
##
## {
##   "namespace": "database",
##   "depends": [
##     "_db_query"
##   ],
##   "assumes": [
##     "sql"
##   ]
## }
query() {
    _db_query "${sql}"
}

