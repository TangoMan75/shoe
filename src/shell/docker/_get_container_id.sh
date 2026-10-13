#!/bin/sh

## {
##   "namespace": "src/shell/docker",
##   "summary": "Get container id from name",
##   "requires": [
##     "docker",
##     "false"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/system/_check_installed"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "CONTAINER_NAME",
##       "description": "The name of the container to run.",
##       "type": "str",
##       "required": true
##     },
##     {
##       "position": 2,
##       "name": "TRUNCATE",
##       "description": "Truncate id to 12 characters long.",
##       "type": "bool",
##       "default": true
##     }
##   ]
## }
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

