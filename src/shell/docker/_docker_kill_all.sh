#!/bin/sh

## Kill all running containers with docker
##
## @namespace src/shell/docker
## @requires docker kill ps tr
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/system/_check_installed.sh
_docker_kill_all() {
    _check_installed docker

    __names__="$(docker ps --quiet --format '{{.Names}}' | tr -s '\n' ' ')"
    if [ -z "${__names__}" ]; then
        _echo_info 'no running container\n'

        return 0
    fi

    _echo_info "docker kill ${__names__}\n"
    # shellcheck disable=SC2086
    docker kill ${__names__}
}

