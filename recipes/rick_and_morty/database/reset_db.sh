#!/bin/sh

## Reset database
##
## {
##   "namespace": "database",
##   "depends": [
##     "cache",
##     "create_db",
##     "drop",
##     "schema"
##   ]
## }
reset_db() {
    drop
    create_db
    schema
    force=true; cache
}

