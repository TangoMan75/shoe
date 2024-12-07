#!/bin/sh

## Stop container stack
stop() {
    if [ -z "$(docker compose -v)" ]; then
        echo_error "\"$(basename "${0}")\" requires docker compose plugin\n"
        return 1
    fi

    echo_info 'docker compose stop || true\n'
    docker compose stop || true
}

