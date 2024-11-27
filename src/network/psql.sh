#!/bin/sh

## Open postgres terminal in docker
psql() {
    # synopsys: psql [container_name]
    if [ ! -x "$(command -v docker)" ]; then
        echo_danger "error: \"$0\" requires docker, try: 'sudo apt-get install -y docker.io'\n"
        return 1
    fi
    if [ ${#} -lt 1 ]; then
        echo_danger 'error: some mandatory parameter is missing.\n'
        return 1
    fi
    if [ ${#} -gt 1 ]; then
        echo_danger "error: too many arguments (${#})\n"
        return 1
    fi

    _username="--username root"
    _password="--no-password"
    _dbname="--dbname pgsql"

    _wait_for_postgres "$1"

    echo_info "docker exec --interactive \"$1\" psql \"${_username}\" \"${_password}\" \"${_dbname}\"\n"
    docker exec --interactive "$1" psql "${_username}" "${_password}" "${_dbname}"
}

