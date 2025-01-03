#!/bin/sh

# Checks if given container is running
_is_container_running() {
    # Synopsis: _is_container_running <CONTAINER_NAME|CONTAINER_ID>
    #   CONTAINER_NAME:  The name of the docker container.
    #   CONTAINER_ID:    The id of the docker container.

    _check_installed docker

    if [ -z "$1" ]; then echo_danger 'error: _is_container_running: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _is_container_running: too many arguments (${#})\n"; return 1; fi

    # set error code status to 1
    set -- "$1" 1

    if docker ps --format '{{.Names}}' 2>/dev/null | grep -E -q "^$1$"; then
        set -- "$1" 0
    fi

    if docker ps --format '{{truncate .ID 12}}' 2>/dev/null | grep -E -q "^$1$"; then
        set -- "$1" 0
    fi

    # return error code
    return "$2"
}

