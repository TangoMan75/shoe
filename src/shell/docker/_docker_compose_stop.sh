#!/bin/sh

# Stop container stack with docker compose
_docker_compose_stop() {
    # Synopsis: _docker_compose_stop

    echo_info "$(_get_docker_compose) stop\n"
    $(_get_docker_compose) stop
}

