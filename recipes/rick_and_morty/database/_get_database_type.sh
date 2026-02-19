#!/bin/sh

## {
##   "namespace": "recipes/rick_and_morty/database",
##   "summary": "Get database type",
##   "requires": [
##     "awk",
##     "echo"
##   ],
##   "depends": [
##     "recipes/rick_and_morty/development/_dotenv"
##   ]
## }
_get_database_type() {
    _dotenv

    echo "${DATABASE_URL}" | awk -F ':' '{print $1}'
}

