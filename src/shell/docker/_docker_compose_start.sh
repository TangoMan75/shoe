#!/bin/sh

# Build and start container stack with docker compose
_docker_compose_start() {
    # Synopsis: _docker_compose_start

    echo_info "$(_get_docker_compose) up --detach --remove-orphans\n"
    $(_get_docker_compose) up --detach --remove-orphans
}

