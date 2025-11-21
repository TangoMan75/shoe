#!/bin/sh

# Get container name from id
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
#       "name": "CONTAINER_ID",
#       "type": "str",
#       "description": "The container id.",
#       "nullable": false
#     }
#   ]
# }
_get_container_name() {
    # Synopsis: _get_container_name <CONTAINER_ID>
    #   CONTAINER_ID: The container id.

    _check_installed docker

    if [ -z "$1" ]; then echo_danger 'error: _get_container_name: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then echo_danger "error: _get_container_name: too many arguments ($#)\n"; return 1; fi

    docker inspect "$1" --format '{{slice .Name 1}}'
}

