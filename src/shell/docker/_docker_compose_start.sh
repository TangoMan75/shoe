#!/bin/sh

## Build and start container stack with docker compose
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
##     },
##     {
##       "position": 2,
##       "name": "ENV_FILE",
##       "type": "file",
##       "description": "The path to the env file."
##     }
##   ]
## }
_docker_compose_start() {
    # Synopsis: _docker_compose_start [FILE_PATH] [ENV_FILE]
    #   FILE_PATH: (optional) The path to the compose.yaml file.
    #   ENV_FILE:  (optional) The path to the env file.

    if [ $# -gt 2 ]; then _echo_error "_docker_compose_start: too many arguments ($#)\n"; return 1; fi

    if [ $# -eq 2 ]; then
        if [ ! -f "$1" ]; then _echo_error "_docker_compose_start: \"$1\" file not found\n"; return 1; fi
        if [ ! -f "$2" ]; then _echo_error "_docker_compose_start: \"$2\" file not found\n"; return 1; fi
        set -- "$(realpath "$1")" "$(realpath "$2")"

        _echo_info "$(_get_docker_compose) --file \"$1\" --env-file \"$2\" up --detach --remove-orphans\n"
        $(_get_docker_compose) --file "$1" --env-file "$2" up --detach --remove-orphans

        return 0
    fi

    if [ $# -eq 1 ]; then
        if [ ! -f "$1" ]; then _echo_error "_docker_compose_start: \"$1\" file not found\n"; return 1; fi
        set -- "$(realpath "$1")"

        _echo_info "$(_get_docker_compose) --file \"$1\" up --detach --remove-orphans\n"
        $(_get_docker_compose) --file "$1" up --detach --remove-orphans

        return 0
    fi

    _echo_info "$(_get_docker_compose) up --detach --remove-orphans\n"
    $(_get_docker_compose) up --detach --remove-orphans
}

