#!/bin/sh

## Update app : git pull, reset database and import (docker)
update() {
    if [ -z "$(docker compose -v)" ]; then
        echo_error "\"$(basename "${0}")\" requires docker compose plugin\n"
        return 1
    fi

    echo_info 'git remote update origin --prune\n'
    git remote update origin --prune

    if [ "${force}" = true ]; then
        if [ "${env}" = dev ]; then
            echo_info 'git reset --hard origin/dev\n'
            git reset --hard origin/dev
        else
            echo_info 'git reset --hard origin/main\n'
            git reset --hard origin/main
        fi
    else
        echo_info 'git pull\n'
        git pull
    fi

    echo_info "docker compose exec -T php sh -c \"sh entrypoint.sh reset_db --env ${env}\"\n"
    docker compose exec -T php sh -c "sh entrypoint.sh reset_db --env ${env}"

    if [ "${import}" = true ]; then
        echo_info "docker compose exec -T php sh -c \"sh entrypoint.sh import --env ${env}\"\n"
        docker compose exec -T php sh -c "sh entrypoint.sh import --env ${env}"
    fi

    echo_info "docker compose exec -T php sh -c \"sh entrypoint.sh cache --force --env ${env}\"\n"
    docker compose exec -T php sh -c "sh entrypoint.sh cache --force --env ${env}"

    echo_info "docker compose exec -T php sh -c \"sh entrypoint.sh cache --env ${env}\"\n"
    docker compose exec -T php sh -c "sh entrypoint.sh cache --env ${env}"
}

