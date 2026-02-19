#!/bin/sh

## Create network, build container, start docker, composer install, create database, import data
##
## {
##   "namespace": "docker",
##   "requires": [
##     "docker"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_info",
##     "build",
##     "network",
##     "start"
##   ]
## }
up() {
    _alert_primary "Spawning project with \"${env}\" environment"

    if [ -z "$(docker compose -v)" ]; then
        _echo_error "\"$(basename "${0}")\" requires docker compose plugin\n"
        return 1
    fi

    network
    build
    start

    _echo_info "docker compose exec php sh -c \"sh entrypoint.sh install --env ${env}\"\n"
    docker compose exec php sh -c "sh entrypoint.sh install --env ${env}"

    if [ "${import}" = true ]; then
        _echo_info "docker compose exec php sh -c \"sh entrypoint.sh import --env ${env}\"\n"
        docker compose exec php sh -c "sh entrypoint.sh import --env ${env}"
    fi

    _echo_info "docker compose exec php sh -c \"sh entrypoint.sh cache --force --env ${env}\"\n"
    docker compose exec php sh -c "sh entrypoint.sh cache --force --env ${env}"

    _echo_info "docker compose exec php sh -c \"sh entrypoint.sh cache --env ${env}\"\n"
    docker compose exec php sh -c "sh entrypoint.sh cache --env ${env}"
}

