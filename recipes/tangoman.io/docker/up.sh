#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/docker",
##   "summary": "Create network, build container, start docker, composer install, create database, import data",
##   "requires": [
##     "basename",
##     "docker",
##     "php",
##     "sh",
##     "true"
##   ],
##   "depends": [
##     "recipes/tangoman.io/docker/build",
##     "recipes/tangoman.io/docker/network",
##     "recipes/tangoman.io/docker/start",
##     "src/shell/colors/_alert_primary",
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info"
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

