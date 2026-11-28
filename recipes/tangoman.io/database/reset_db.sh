#!/bin/sh

## Reset database (without imports)
##
## @namespace recipes/tangoman.io/database
## @requires true
## @depends recipes/tangoman.io/database/create_db.sh
## @depends recipes/tangoman.io/database/drop.sh
## @depends recipes/tangoman.io/database/migrate.sh
## @depends recipes/tangoman.io/database/schema.sh
## @depends recipes/tangoman.io/symfony/cache.sh
## @assumes migrate
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

