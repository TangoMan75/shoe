#!/bin/sh

## Build containers
build() {
    if [ -z "$(docker compose -v)" ]; then
        echo_error "\"$(basename "${0}")\" requires docker compose plugin\n"
        return 1
    fi

    _database_type=$(_get_database_type)

    if [ "${_database_type}" = sqlite ]; then
        if [ "${env}" = prod ]; then
            echo_info 'docker compose -f compose.prod.yml build\n'
            docker compose -f compose.prod.yml build
        elif [ "${env}" = dev ]; then
            echo_info 'docker compose -f compose.dev.yml build\n'
            docker compose -f compose.dev.yml build
        else
            echo_info 'docker compose build\n'
            docker compose build
        fi
    fi

    if [ "${_database_type}" = postgresql ]; then
        if [ "${env}" = prod ]; then
            echo_info 'docker compose -f compose.postgres.prod.yml build\n'
            docker compose -f compose.postgres.prod.yml build
        elif [ "${env}" = dev ]; then
            echo_info 'docker compose -f compose.postgres.dev.yml build\n'
            docker compose -f compose.postgres.dev.yml build
        else
            echo_info 'docker compose -f compose.postgres.yml build\n'
            docker compose -f compose.postgres.yml build
        fi
    fi

}

