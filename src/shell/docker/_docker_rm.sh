#!/bin/sh

# Remove given docker container
_docker_rm() {
    # Synopsis: _docker_rm <CONTAINER_NAME>
    #   CONTAINER_NAME: The name of the container to remove.

    _check_installed docker

    if [ -z "$1" ]; then echo_danger 'error: _docker_rm: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _docker_rm: too many arguments (${#})\n"; return 1; fi

    echo_info "docker rm \"$1\"\n"
    docker rm "$1"
}

