#!/bin/sh

## Return docker compose command
##
## @namespace src/shell/docker
## @requires basename command docker docker-compose echo
## @depends src/shell/colors/_echo_error
_get_docker_compose() {
    if docker compose >/dev/null 2>&1; then
        echo 'docker compose'

        return 0
    fi

    if [ -x "$(command -v docker-compose)" ]; then
        echo 'docker-compose'

        return 0
    fi

    _echo_error "\"$(basename "${0}")\" requires docker-compose or docker compose plugin\n"

    exit 1
}

