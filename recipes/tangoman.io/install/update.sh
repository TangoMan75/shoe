#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/install",
##   "summary": "Update app : git pull, reset database and import (docker)",
##   "requires": [
##     "basename",
##     "docker",
##     "git",
##     "php",
##     "reset",
##     "sh",
##     "true"
##   ],
##   "depends": [
##     "recipes/tangoman.io/docker/restart",
##     "recipes/tangoman.io/docker/start",
##     "recipes/tangoman.io/docker/stop",
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info"
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

