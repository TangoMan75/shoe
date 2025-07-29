#!/bin/sh

# Wait for postgresql container to start with docker
_wait_for_postgres() {
    # Synopsis: _wait_for_postgres <CONTAINER_NAME> [USERNAME]
    #   CONTAINER_NAME: The name of the postgresql docker container.
    #   USERNAME:       (optional) The psql username. Defaults to "".

    _check_installed docker

    if [ -z "$1" ]; then echo_danger 'error: _wait_for_postgres: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _wait_for_postgres: too many arguments (${#})\n"; return 1; fi

    if [ -n "$2" ]; then
        set -- "$1" "--username $2"
    fi

    echo_warning "Waiting for \"$1\" database to start."

    while [ ! "$(docker exec "$1" psql "$2" -l 2>/dev/null)" ]; do
        _spin 600
    done

    echo_success "\n\"$1\" is runnning.\n"
}

