#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/database",
##   "summary": "Reset database (without imports)",
##   "requires": [
##     "true"
##   ],
##   "depends": [
##     "recipes/tangoman.io/database/create_db",
##     "recipes/tangoman.io/database/drop",
##     "recipes/tangoman.io/database/migrate",
##     "recipes/tangoman.io/database/schema",
##     "recipes/tangoman.io/symfony/cache"
##   ],
##   "assumes": [
##     "migrate"
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

