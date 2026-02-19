#!/bin/sh

## Build and start container stack
##
## {
##   "namespace": "docker",
##   "requires": [
##     "docker"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_info"
##   ]
## }
start() {
    if [ -z "$(docker compose -v)" ]; then
        _echo_error "\"$(basename "${0}")\" requires docker compose plugin\n"
        return 1
    fi

    _database_type=$(_get_database_type)

    if [ "${_database_type}" = sqlite ]; then
        if [ "${env}" = prod ]; then
            _echo_info 'docker compose -f compose.prod.yml up --detach --remove-orphans\n'
            docker compose -f compose.prod.yml up --detach --remove-orphans
        elif [ "${env}" = dev ]; then
            _echo_info 'docker compose -f compose.dev.yml up --detach --remove-orphans\n'
            docker compose -f compose.dev.yml up --detach --remove-orphans
        else
            _echo_info 'docker compose up --detach --remove-orphans\n'
            docker compose up --detach --remove-orphans
        fi
    fi

    if [ "${_database_type}" = postgresql ]; then
        if [ "${env}" = prod ]; then
            _echo_info 'docker compose -f compose.postgres.prod.yml up --detach --remove-orphans\n'
            docker compose -f compose.postgres.prod.yml up --detach --remove-orphans
        elif [ "${env}" = dev ]; then
            _echo_info 'docker compose -f compose.postgres.dev.yml up --detach --remove-orphans\n'
            docker compose -f compose.postgres.dev.yml up --detach --remove-orphans
        else
            _echo_info 'docker compose -f compose.postgres.yml up --detach --remove-orphans\n'
            docker compose -f compose.postgres.yml up --detach --remove-orphans
        fi
    fi
}

