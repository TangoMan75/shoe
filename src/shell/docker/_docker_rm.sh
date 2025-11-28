#!/bin/sh

## Remove given docker container
##
## {
##   "namespace": "docker",
##   "requires": [
##     "docker"
##   ],
##   "depends": [
##     "_check_installed",
##     "_echo_error",
##     "_echo_info"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "CONTAINER_NAME",
##       "type": "str",
##       "description": "The name of the container to run.",
##       "nullable": false
##     }
##   ]
## }
_docker_rm() {
    # Synopsis: _docker_rm <CONTAINER_NAME>
    #   CONTAINER_NAME: The name of the container to remove.

    _check_installed docker

    if [ -z "$1" ]; then _echo_error '_docker_rm: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_docker_rm: too many arguments ($#)\n"; return 1; fi

    _echo_info "docker rm \"$1\"\n"
    docker rm "$1"
}

