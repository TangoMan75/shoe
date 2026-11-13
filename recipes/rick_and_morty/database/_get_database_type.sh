#!/bin/sh

## Get database type
##
## @namespace recipes/rick_and_morty/database
## @requires awk echo
## @depends recipes/rick_and_morty/development/_dotenv
## @assumes DATABASE_URL
_get_database_type() {
    _dotenv

    echo "${DATABASE_URL}" | awk -F ':' '{print $1}'
}

