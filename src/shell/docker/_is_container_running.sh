#!/bin/sh

## Checks if given container is running
##
## @namespace src/shell/docker
## @requires docker true
## @depends src/shell/colors/_echo_error src/shell/system/_check_installed
## @param {str} <CONTAINER_NAME|CONTAINER_ID> (required) The name or the id of the docker container.
_is_container_running() {
    _check_installed docker

    if [ -z "$1" ]; then _echo_error '_is_container_running: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_is_container_running: too many arguments ($#)\n"; return 1; fi

    if [ "$(docker inspect "$1" --format '{{.State.Running}}' 2>/dev/null)" = true ]; then

        return 0
    fi

    return 1
}

