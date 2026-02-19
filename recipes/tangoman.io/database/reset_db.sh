#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/database",
##   "summary": "Reset database (without imports)",
##   "requires": [
##     "true"
##   ],
##   "depends": [
##     "recipes/datadome/database/drop",
##     "recipes/datadome/database/schema",
##     "recipes/datadome/symfony/cache",
##     "recipes/rick_and_morty/doctrine/create_db",
##     "recipes/rick_and_morty/doctrine/migrate"
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

