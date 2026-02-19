#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/database",
##   "summary": "Dump MySQL database (docker)",
##   "requires": [
##     "basename",
##     "date",
##     "docker"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info"
##   ]
## }
mysqldump() {
    if [ -z "$(docker compose -v)" ]; then
        _echo_error "\"$(basename "${0}")\" requires docker compose plugin\n"
        return 1
    fi

    # echo_info "mysqldump --add-drop-table -u root -ptoor \"${env}\" > \"/data/dump_${env}_$(date '+%Y-%m-%d_%H-%M-%S').sql\"\n"
    # mysqldump --add-drop-table -u root -ptoor "${env}" > "/data/dump_${env}_$(date '+%Y-%m-%d_%H-%M-%S').sql"

    _echo_info "docker compose exec mysqldump --add-drop-table -u root -ptoor \"${env}\" > \"/data/dump_${env}_$(date '+%Y-%m-%d_%H-%M-%S').sql\"\n"
    docker compose exec mysqldump --add-drop-table -u root -ptoor "${env}" > "/data/dump_${env}_$(date '+%Y-%m-%d_%H-%M-%S').sql"
}

