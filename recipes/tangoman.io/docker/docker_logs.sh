#!/bin/sh

## Print Docker log
##
## @namespace recipes/tangoman.io/docker
## @requires basename docker
## @depends recipes/tangoman.io/docker/container_name.sh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
docker_logs() {
    if [ -z "$(docker compose -v)" ]; then
        _echo_error "\"$(basename "${0}")\" requires docker compose plugin\n"
        return 1
    fi

    _echo_info "docker compose logs -f \"$(container_name)\"\n"
    docker compose logs -f "$(container_name)"
}

