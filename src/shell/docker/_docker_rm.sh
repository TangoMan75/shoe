#!/bin/sh

## {
##   "namespace": "src/shell/docker",
##   "summary": "Remove given docker container",
##   "requires": [
##     "docker",
##     "rm"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_check_installed"
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

