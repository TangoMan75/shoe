#!/bin/sh

## Return docker compose command
##
## @namespace src/shell/docker
## @requires basename command docker docker-compose printf
## @depends src/shell/colors/_echo_error
_docker_compose() {
    if docker compose >/dev/null 2>&1; then
        printf 'docker compose'

        return 0
    fi

    if [ -x "$(command -v docker-compose)" ]; then
        printf 'docker-compose'

        return 0
    fi

    _echo_error "\"$(basename "${0}")\" requires docker-compose or docker compose plugin\n"

    exit 1
}

