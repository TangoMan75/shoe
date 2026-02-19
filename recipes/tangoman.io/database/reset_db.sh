#!/bin/sh

## Reset database (without imports)
##
## {
##   "namespace": "database",
##   "depends": [
##     "cache",
##     "create_db",
##     "drop",
##     "migrate",
##     "schema"
##   ]
## }
reset_db() {
    drop
    create_db

    if [ "${migrate}" = true ]; then
        migrate
    else
        schema
    fi

    force=true; cache
}

