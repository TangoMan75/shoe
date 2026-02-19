#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/database",
##   "summary": "Get database type from .env file",
##   "requires": [
##     "awk",
##     "echo"
##   ],
##   "depends": [
##     "recipes/tangoman.io/development/_dotenv"
##   ]
## }
_get_database_type() {
    _dotenv

    echo "${DATABASE_URL}" | awk -F ':' '{print $1}'
}

