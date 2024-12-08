#!/bin/sh

## Open postgres terminal in docker
_docker_psql() {
    # Synopsis: _docker_psql <CONTAINER_NAME>
    #   CONTAINER_NAME:  The name of the docker container.

    _check_installed docker

    if [ -z "$1" ]; then echo_danger 'error: _docker_psql: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _docker_psql: too many arguments (${#})\n"; return 1; fi

    _username="--username root"
    _password="--no-password"
    _dbname="--dbname pgsql"

    _docker_wait_for_postgres "$1"

    echo_info "docker exec --interactive \"$1\" psql \"${_username}\" \"${_password}\" \"${_dbname}\"\n"
    docker exec --interactive "$1" psql "${_username}" "${_password}" "${_dbname}"
}

