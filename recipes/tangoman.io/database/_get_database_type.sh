#!/bin/sh

## Get database type from .env file
##
## @namespace recipes/tangoman.io/database
## @requires awk echo
## @depends recipes/tangoman.io/development/_dotenv
## @assumes DATABASE_URL
_get_database_type() {
    _dotenv

    echo "${DATABASE_URL}" | awk -F ':' '{print $1}'
}

