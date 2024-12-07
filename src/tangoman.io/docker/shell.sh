#!/bin/sh

## Shell into "php" container
shell() {
    if [ -z "$(docker compose -v)" ]; then
        echo_error "\"$(basename "${0}")\" requires docker compose plugin\n"
        return 1
    fi

    clear
    echo_info 'docker compose exec -it php sh\n'
    docker compose exec -it php sh
}

