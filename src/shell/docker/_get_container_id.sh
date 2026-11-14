#!/bin/sh

## Get container id from name
##
## @namespace src/shell/docker
## @requires docker false
## @depends src/shell/colors/_echo_error src/shell/system/_check_installed
## @param {str} <CONTAINER_NAME> (required) The name of the container to run.
## @param {bool} <TRUNCATE> (default:true) Truncate id to 12 characters long.
_get_container_id() {
    _check_installed docker

    if [ -z "$1" ]; then _echo_error '_get_container_id: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_container_id: too many arguments ($#)\n"; return 1; fi

    set -- "$1" "${2:-true}"

    if [ "$2" = false ]; then
        docker inspect "$1" --format='{{.Id}}' || return 1

        return 0
    fi

    docker inspect "$1" --format='{{truncate .Id 13}}'
}

