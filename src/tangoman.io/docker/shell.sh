#!/bin/sh

## Shell into "php" container
shell() {
    clear
    echo_info 'docker compose exec -it php sh\n'
    docker compose exec -it php sh
}

