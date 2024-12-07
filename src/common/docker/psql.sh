#!/bin/sh

## Open postgres terminal in docker
psql() {
    # Synopsis: psql [container_name]

    _check_installed docker

    if [ ${#} -lt 1 ]; then echo_danger 'error: psql: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: psql: too many arguments (${#})\n"; return 1; fi

    _username="--username root"
    _password="--no-password"
    _dbname="--dbname pgsql"

    _wait_for_postgres "$1"

    echo_info "docker exec --interactive \"$1\" psql \"${_username}\" \"${_password}\" \"${_dbname}\"\n"
    docker exec --interactive "$1" psql "${_username}" "${_password}" "${_dbname}"
}

