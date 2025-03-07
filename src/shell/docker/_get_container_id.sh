#!/bin/sh

# Get container id from name
_get_container_id() {
    # Synopsis: _get_container_id <CONTAINER_NAME> [TRUNCATE]
    #   CONTAINER_NAME: The container name.
    #   TRUNCATE:       Truncate id to 12 characters long. Defaults to "true".

    _check_installed docker

    if [ -z "$1" ]; then echo_danger 'error: _get_container_id: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_container_id: too many arguments (${#})\n"; return 1; fi

    set -- "$1" "${2:-true}"

    if [ "$2" = false ]; then
        docker inspect "$1" --format='{{.Id}}' || return 1

        return 0
    fi

    docker inspect "$1" --format='{{truncate .Id 13}}'
}

