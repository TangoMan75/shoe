#!/bin/sh

## Reset database (without imports)
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

