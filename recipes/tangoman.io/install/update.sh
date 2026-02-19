#!/bin/sh

## Update app : git pull, reset database and import (docker)
##
## {
##   "namespace": "install",
##   "requires": [
##     "docker"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_info",
##     "restart",
##     "start",
##     "stop"
##   ]
## }
update() {
    if [ -z "$(docker compose -v)" ]; then
        _echo_error "\"$(basename "${0}")\" requires docker compose plugin\n"
        return 1
    fi

    stop

    _echo_info 'git remote update origin --prune\n'
    git remote update origin --prune

    if [ "${force}" = true ]; then
        if [ "${env}" = dev ]; then
            _echo_info 'git reset --hard origin/dev\n'
            git reset --hard origin/dev
        else
            _echo_info 'git reset --hard origin/main\n'
            git reset --hard origin/main
        fi
    else
        _echo_info 'git pull\n'
        git pull
    fi

    start

    _echo_info "docker compose exec -T php sh -c \"sh entrypoint.sh uninstall --env ${env}\"\n"
    docker compose exec -T php sh -c "sh entrypoint.sh uninstall --env ${env}"

    _echo_info "docker compose exec -T php sh -c \"sh entrypoint.sh install --env ${env}\"\n"
    docker compose exec -T php sh -c "sh entrypoint.sh install --env ${env}"

    if [ "${import}" = true ]; then
        _echo_info "docker compose exec -T php sh -c \"sh entrypoint.sh import --env ${env}\"\n"
        docker compose exec -T php sh -c "sh entrypoint.sh import --env ${env}"
    fi

    restart
}

