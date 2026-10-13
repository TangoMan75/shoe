#!/bin/sh

## {
##   "namespace": "src/shell/docker",
##   "summary": "Get container name from id",
##   "requires": [
##     "docker"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/system/_check_installed"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "CONTAINER_ID",
##       "description": "The container id.",
##       "type": "str",
##       "required": true
##     }
##   ]
## }
_get_container_name() {
    _check_installed docker

    if [ -z "$1" ]; then _echo_error '_get_container_name: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_container_name: too many arguments ($#)\n"; return 1; fi

    docker inspect "$1" --format '{{slice .Name 1}}'
}

