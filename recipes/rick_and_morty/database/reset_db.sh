#!/bin/sh

## {
##   "namespace": "recipes/rick_and_morty/database",
##   "summary": "Reset database",
##   "requires": [
##     "true"
##   ],
##   "depends": [
##     "recipes/datadome/database/drop",
##     "recipes/datadome/database/schema",
##     "recipes/datadome/symfony/cache",
##     "recipes/rick_and_morty/doctrine/create_db"
##   ]
## }
reset_db() {
    drop
    create_db
    schema
    force=true; cache
}

