#!/bin/sh

## {
##   "namespace": "src/shell/docker",
##   "summary": "Checks if given container is running",
##   "requires": [
##     "docker",
##     "true"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/system/_check_installed"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "CONTAINER_NAME|CONTAINER_ID",
##       "type": "str",
##       "description": "The name or the id of the docker container.",
##       "required": true
##     }
##   ]
## }
_is_container_running() {
    # Synopsis: _is_container_running <CONTAINER_NAME|CONTAINER_ID>
    #   CONTAINER_NAME: The name of the docker container.
    #   CONTAINER_ID:   The id of the docker container.

    _check_installed docker

    if [ -z "$1" ]; then _echo_error '_is_container_running: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_is_container_running: too many arguments ($#)\n"; return 1; fi

    if [ "$(docker inspect "$1" --format '{{.State.Running}}' 2>/dev/null)" = true ]; then

        return 0
    fi

    return 1
}

