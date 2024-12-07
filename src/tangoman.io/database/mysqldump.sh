#!/bin/sh

## Dump MySQL database (docker)
mysqldump() {
    if [ -z "$(docker compose -v)" ]; then
        echo_error "\"$(basename "${0}")\" requires docker compose plugin\n"
        return 1
    fi

    # echo_info "mysqldump --add-drop-table -u root -ptoor \"${env}\" > \"/data/dump_${env}_$(date '+%Y-%m-%d_%H-%M-%S').sql\"\n"
    # mysqldump --add-drop-table -u root -ptoor "${env}" > "/data/dump_${env}_$(date '+%Y-%m-%d_%H-%M-%S').sql"

    echo_info "docker compose exec mysqldump --add-drop-table -u root -ptoor \"${env}\" > \"/data/dump_${env}_$(date '+%Y-%m-%d_%H-%M-%S').sql\"\n"
    docker compose exec mysqldump --add-drop-table -u root -ptoor "${env}" > "/data/dump_${env}_$(date '+%Y-%m-%d_%H-%M-%S').sql"
}

