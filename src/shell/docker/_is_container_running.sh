#!/bin/sh

# Checks if given container is running
_is_container_running() {
    # Synopsis: _is_container_running <CONTAINER_NAME|CONTAINER_ID>
    #   CONTAINER_NAME: The name of the docker container.
    #   CONTAINER_ID:   The id of the docker container.

    _check_installed docker

    if [ -z "$1" ]; then echo_danger 'error: _is_container_running: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _is_container_running: too many arguments (${#})\n"; return 1; fi

    if [ "$(docker inspect "$1" --format '{{.State.Running}}' 2>/dev/null)" = true ]; then

        return 0
    fi

    return 1
}

