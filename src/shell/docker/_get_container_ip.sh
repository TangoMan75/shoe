#!/bin/sh

# Get running container ip
#
# {
#   "namespace": "docker",
#   "requires": [
#     "docker"
#   ],
#   "depends": [
#     "_check_installed",
#     "echo_danger"
#   ],
#   "parameters": [
#     {
#       "position": 1,
#       "name": "CONTAINER_NAME|CONTAINER_ID",
#       "type": "str",
#       "description": "The name or the id of the docker container.",
#       "nullable": false
#     }
#   ]
# }
_get_container_ip() {
    # Synopsis: _get_container_ip <CONTAINER_NAME|CONTAINER_ID>
    #   CONTAINER_NAME: The name of the docker container.
    #   CONTAINER_ID:   The id of the docker container.

    _check_installed docker

    if [ -z "$1" ]; then echo_danger 'error: _get_container_ip: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then echo_danger "error: _get_container_ip: too many arguments ($#)\n"; return 1; fi

    if [ "$(docker inspect "$1" --format '{{.State.Running}}' 2>/dev/null)" != true ]; then

        return 1
    fi

    set -- "$(docker inspect "$1" --format '{{.NetworkSettings.IPAddress}}' 2>/dev/null)"

    if [ -z "$1" ]; then
        printf '%s' 127.0.0.1

        return 0
    fi

    printf '%s' "$1"
}

