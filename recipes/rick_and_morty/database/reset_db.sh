#!/bin/sh

## Reset database
##
## @namespace recipes/rick_and_morty/database
## @requires true
## @depends recipes/rick_and_morty/doctrine/create_db.sh
## @depends recipes/rick_and_morty/doctrine/drop.sh
## @depends recipes/rick_and_morty/doctrine/schema.sh
## @depends recipes/rick_and_morty/symfony/cache.sh
reset_db() {
    drop
    create_db
    schema
    force=true; cache
}

