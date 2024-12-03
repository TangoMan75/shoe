#!/bin/sh

## Print Docker log
docker_logs() {
    echo_info "docker compose logs -f \"$(container_name)\"\n"
    docker compose logs -f "$(container_name)"
}

