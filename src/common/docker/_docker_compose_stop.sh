#!/bin/sh

# Stop container stack with docker-compose
_docker_compose_stop() {
    # Synopsis: _docker_compose_stop

    _check_installed docker-compose

    if [ ${#} -gt 0 ]; then echo_danger "error: _docker_compose_stop: too many arguments (${#})\n"; return 1; fi

    echo_info 'docker-compose stop\n'
    docker-compose stop
}

