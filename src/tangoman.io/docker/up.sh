#!/bin/sh

## Create network, build container, start docker, composer install, create database, import data
up() {
    alert_primary "Spawning project with \"${env}\" environment"

    if [ -z "$(docker compose -v)" ]; then
        echo_error "\"$(basename "${0}")\" requires docker compose plugin\n"
        return 1
    fi

    network
    build
    start

    echo_info "docker compose exec php sh -c \"sh entrypoint.sh install --env ${env}\"\n"
    docker compose exec php sh -c "sh entrypoint.sh install --env ${env}"

    if [ "${import}" = true ]; then
        echo_info "docker compose exec php sh -c \"sh entrypoint.sh import --env ${env}\"\n"
        docker compose exec php sh -c "sh entrypoint.sh import --env ${env}"
    fi

    echo_info "docker compose exec php sh -c \"sh entrypoint.sh cache --force --env ${env}\"\n"
    docker compose exec php sh -c "sh entrypoint.sh cache --force --env ${env}"

    echo_info "docker compose exec php sh -c \"sh entrypoint.sh cache --env ${env}\"\n"
    docker compose exec php sh -c "sh entrypoint.sh cache --env ${env}"
}

