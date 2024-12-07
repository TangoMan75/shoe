#!/bin/sh

## Load local sql script
load_sql() {
    # Synopsis: load_sql CONTAINER_NAME

    _check_installed docker

    if [ ${#} -lt 1 ]; then echo_danger 'error: load_sql: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: load_sql: too many arguments (${#})\n"; return 1; fi

    if [ -z "${file}" ]; then
        echo_danger "error: load_sql: file cannot be empty\n"
        return 1
    fi

    _username="--username root"
    _password="--no-password"
    _dbname="--dbname pgsql"

    _wait_for_postgres "$1"

    file="$(realpath "${file}")"

    echo_info "docker exec --interactive \"$1\" psql \"${_username}\" \"${_password}\" \"${_dbname}\" < \"${file}\"\n"
    docker exec --interactive "$1" psql "${_username}" "${_password}" "${_dbname}" < "${file}"
}

