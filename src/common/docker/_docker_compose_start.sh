#!/bin/sh

# Build and start container stack with docker-compose
_docker_compose_start() {
    # Synopsis: _docker_compose_start

    _check_installed docker-compose

    if [ ${#} -gt 0 ]; then echo_danger "error: _docker_compose_stop: too many arguments (${#})\n"; return 1; fi

    echo_info 'docker-compose up --detach --remove-orphans\n'
    docker-compose up --detach --remove-orphans
}

