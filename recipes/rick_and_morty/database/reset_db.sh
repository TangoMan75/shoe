#!/bin/sh

## {
##   "namespace": "recipes/rick_and_morty/database",
##   "summary": "Reset database",
##   "requires": [
##     "true"
##   ],
##   "depends": [
##     "recipes/rick_and_morty/doctrine/create_db",
##     "recipes/rick_and_morty/doctrine/drop",
##     "recipes/rick_and_morty/doctrine/schema",
##     "recipes/rick_and_morty/symfony/cache"
##   ]
## }
reset_db() {
    drop
    create_db
    schema
    force=true; cache
}

