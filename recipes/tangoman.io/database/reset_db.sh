#!/bin/sh

## Reset database (without imports)
##
## @namespace recipes/tangoman.io/database
## @requires true
## @depends recipes/tangoman.io/database/create_db
## @depends recipes/tangoman.io/database/drop
## @depends recipes/tangoman.io/database/migrate
## @depends recipes/tangoman.io/database/schema
## @depends recipes/tangoman.io/symfony/cache
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

