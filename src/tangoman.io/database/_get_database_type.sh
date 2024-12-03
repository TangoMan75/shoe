#!/bin/sh

## Check database type
_get_database_type() {
    _dotenv

    echo "${DATABASE_URL}" | awk -F ':' '{print $1}'
}

