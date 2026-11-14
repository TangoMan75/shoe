#!/bin/sh

## Remove given docker container
##
## @namespace src/shell/docker
## @requires docker rm
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/system/_check_installed
## @param {str} <CONTAINER_NAME> (required) The name of the container to run.
_docker_rm() {
    _check_installed docker

    if [ -z "$1" ]; then _echo_error '_docker_rm: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_docker_rm: too many arguments ($#)\n"; return 1; fi

    _echo_info "docker rm \"$1\"\n"
    docker rm "$1"
}

