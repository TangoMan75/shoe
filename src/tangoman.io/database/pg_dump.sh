#!/bin/sh

## Dump Postgres database (docker)
pg_dump() {
    # echo_info "postgres pg_dump \"${env}\" > \"./data/dump_${env}_$(date '+%Y-%m-%d_%H-%M-%S').sql\"\n"
    # postgres pg_dump "${env}" > "./data/dump_${env}_$(date '+%Y-%m-%d_%H-%M-%S').sql"

    echo_info "docker compose exec postgres pg_dump \"${env}\" > \"./data/dump_${env}_$(date '+%Y-%m-%d_%H-%M-%S').sql\"\n"
    docker compose exec postgres pg_dump "${env}" > "./data/dump_${env}_$(date '+%Y-%m-%d_%H-%M-%S').sql"
}

