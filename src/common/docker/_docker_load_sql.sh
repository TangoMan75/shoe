#!/bin/sh

# Load local sql script
_docker_load_sql() {
    # Synopsis: _docker_load_sql <CONTAINER_NAME> <FILE_PATH>
    #   CONTAINER_NAME:  The name of the docker container.
    #   FILE_PATH:       The path to the sql file.

    _check_installed docker

    if [ ${#} -lt 2 ] || [ -z "$1" ]; then echo_danger 'error: _docker_load_sql: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _docker_load_sql: too many arguments (${#})\n"; return 1; fi

    # set default values
    set -- "$1" "$(realpath "$1")"
    if [ ! -f "$2" ]; then echo_danger "error: _docker_load_sql: \"$2\" file not found\n"; return 1; fi

    _username="--username root"
    _password="--no-password"
    _dbname="--dbname pgsql"

    _wait_for_postgres "$1"

    echo_info "docker exec --interactive \"$1\" psql \"${_username}\" \"${_password}\" \"${_dbname}\" < \"$2\"\n"
    docker exec --interactive "$1" psql "${_username}" "${_password}" "${_dbname}" < "$2"
}

