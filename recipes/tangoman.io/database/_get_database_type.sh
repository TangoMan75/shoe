#!/bin/sh

## Get database type
##
## {
##   "namespace": "database",
##   "requires": [
##     "awk"
##   ],
##   "depends": [
##     "_dotenv"
##   ]
## }
_get_database_type() {
    _dotenv

    echo "${DATABASE_URL}" | awk -F ':' '{print $1}'
}

