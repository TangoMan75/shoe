#!/bin/sh

# Kill all running containers with docker
_docker_kill_all() {
    # Synopsis: _docker_kill_all

    _check_installed docker

    echo_info "docker kill $(docker ps --quiet --format '{{.Names}}' | tr -s "\n" ' ')\n"
    # shellcheck disable=SC2046
    docker kill $(docker ps --quiet --format '{{.Names}}')
}

