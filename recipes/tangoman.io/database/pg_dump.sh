#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/database",
##   "summary": "Dump Postgres database (docker)",
##   "requires": [
##     "basename",
##     "date",
##     "docker"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info"
##   ],
##   "assumes": [
##     "env"
##   ]
## }
pg_dump() {
    if [ -z "$(docker compose -v)" ]; then
        _echo_error "\"$(basename "${0}")\" requires docker compose plugin\n"
        return 1
    fi

    # echo_info "postgres pg_dump \"${env}\" > \"./data/dump_${env}_$(date '+%Y-%m-%d_%H-%M-%S').sql\"\n"
    # postgres pg_dump "${env}" > "./data/dump_${env}_$(date '+%Y-%m-%d_%H-%M-%S').sql"

    _echo_info "docker compose exec postgres pg_dump \"${env}\" > \"./data/dump_${env}_$(date '+%Y-%m-%d_%H-%M-%S').sql\"\n"
    docker compose exec postgres pg_dump "${env}" > "./data/dump_${env}_$(date '+%Y-%m-%d_%H-%M-%S').sql"
}

