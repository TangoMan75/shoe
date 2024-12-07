#!/bin/sh

# Check if database is installed
_is_database_installed() {
    _database_type=$(_get_database_type)

    if [ "${_database_type}" = sqlite ] && [ -f ./var/${env}.db ]; then
        echo true
        return 0
    fi

    # if [ "${_database_type}" = postgresql ]; then
    #     if ./bin/console doctrine:query:sql "SELECT datname FROM pg_catalog.pg_database WHERE datname = '${env}'" | grep -q "${env}"; then
    #         echo true
    #         return 0
    #     fi
    # fi

    # if [ "${_database_type}" = mysql ]; then
    #     if ./bin/console doctrine:query:sql "SELECT schema_name FROM information_schema.schemata WHERE schema_name = '${env}'" | grep -q "${env}"; then
    #         echo true
    #         return 0
    #     fi
    # fi

    echo false
}

