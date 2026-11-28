#!/bin/sh

## Create network, build container, start docker, composer install, create database, import data
##
## @namespace recipes/tangoman.io/docker
## @requires basename docker php sh true
## @depends recipes/tangoman.io/docker/build.sh
## @depends recipes/tangoman.io/docker/network.sh
## @depends recipes/tangoman.io/docker/start.sh
## @depends src/shell/colors/_alert_primary.sh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @assumes env import
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

