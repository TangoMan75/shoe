#!/bin/sh

## Print Docker log
docker_logs() {
    if [ -z "$(docker compose -v)" ]; then
        echo_error "\"$(basename "${0}")\" requires docker compose plugin\n"
        return 1
    fi

    echo_info "docker compose logs -f \"$(container_name)\"\n"
    docker compose logs -f "$(container_name)"
}

