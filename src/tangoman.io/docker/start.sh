#!/bin/sh

## Build and start container stack
start() {
    if [ -z "$(docker compose -v)" ]; then
        echo_error "\"$(basename "${0}")\" requires docker compose plugin\n"
        return 1
    fi

    _database_type=$(_get_database_type)

    if [ "${_database_type}" = sqlite ]; then
        if [ "${env}" = prod ]; then
            echo_info 'docker compose -f compose.prod.yml up --detach --remove-orphans\n'
            docker compose -f compose.prod.yml up --detach --remove-orphans
        elif [ "${env}" = dev ]; then
            echo_info 'docker compose -f compose.dev.yml up --detach --remove-orphans\n'
            docker compose -f compose.dev.yml up --detach --remove-orphans
        else
            echo_info 'docker compose up --detach --remove-orphans\n'
            docker compose up --detach --remove-orphans
        fi
    fi

    if [ "${_database_type}" = postgresql ]; then
        if [ "${env}" = prod ]; then
            echo_info 'docker compose -f compose.postgres.prod.yml up --detach --remove-orphans\n'
            docker compose -f compose.postgres.prod.yml up --detach --remove-orphans
        elif [ "${env}" = dev ]; then
            echo_info 'docker compose -f compose.postgres.dev.yml up --detach --remove-orphans\n'
            docker compose -f compose.postgres.dev.yml up --detach --remove-orphans
        else
            echo_info 'docker compose -f compose.postgres.yml up --detach --remove-orphans\n'
            docker compose -f compose.postgres.yml up --detach --remove-orphans
        fi
    fi
}

