#!/bin/sh

## Get container name from id
##
## @namespace src/shell/docker
## @requires docker
## @depends src/shell/colors/_echo_error src/shell/system/_check_installed
## @param {str} <CONTAINER_ID> (required) The container id.
_get_container_name() {
    _check_installed docker

    if [ -z "$1" ]; then _echo_error '_get_container_name: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_container_name: too many arguments ($#)\n"; return 1; fi

    docker inspect "$1" --format '{{slice .Name 1}}'
}

