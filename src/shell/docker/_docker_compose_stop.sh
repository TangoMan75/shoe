#!/bin/sh

## Stop container stack with docker compose
##
## {
##   "namespace": "docker",
##   "depends": [
##     "_get_docker_compose",
##     "_echo_error",
##     "_echo_info"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "FILE_PATH",
##       "type": "file",
##       "description": "The path to the compose.yaml file."
##     }
##   ]
## }
_docker_compose_stop() {
    # Synopsis: _docker_compose_stop [FILE_PATH]
    #   FILE_PATH: (optional) The path to the compose.yaml file.

    if [ $# -gt 1 ]; then _echo_error "_docker_compose_stop: too many arguments ($#)\n"; return 1; fi

    if [ -z "$1" ]; then
        _echo_info "$(_get_docker_compose) stop\n"
        $(_get_docker_compose) stop

        return 0
    fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then _echo_error "_docker_compose_stop: \"$1\" file not found\n"; return 1; fi

    _echo_info "$(_get_docker_compose) --file \"$1\" stop\n"
    $(_get_docker_compose) --file "$1" stop
}

