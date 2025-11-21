#!/bin/sh

# Build and start container stack with docker compose
#
# {
#   "namespace": "docker",
#   "depends": [
#     "_get_docker_compose",
#     "echo_danger",
#     "echo_info"
#   ],
#   "parameters": [
#     {
#       "position": 1,
#       "name": "FILE_PATH",
#       "type": "file",
#       "description": "The path to the compose.yaml file."
#     }
#   ]
# }
_docker_compose_start() {
    # Synopsis: _docker_compose_start [FILE_PATH]
    #   FILE_PATH: (optional) The path to the compose.yaml file.

    if [ $# -gt 1 ]; then echo_danger "error: _docker_compose_start: too many arguments ($#)\n"; return 1; fi

    if [ -z "$1" ]; then
        echo_info "$(_get_docker_compose) up --detach --remove-orphans\n"
        $(_get_docker_compose) up --detach --remove-orphans

        return 0
    fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then echo_danger "error: _docker_compose_start: \"$1\" file not found\n"; return 1; fi

    echo_info "$(_get_docker_compose) --file \"$1\" up --detach --remove-orphans\n"
    $(_get_docker_compose) --file "$1" up --detach --remove-orphans
}

