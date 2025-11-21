#!/bin/sh

# Build container stack with docker compose
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
_docker_compose_build() {
    # Synopsis: _docker_compose_build [FILE_PATH]
    #   FILE_PATH: (optional) The path to the compose.yaml file.

    if [ $# -gt 1 ]; then echo_danger "error: _docker_compose_build: too many arguments ($#)\n"; return 1; fi

    if [ -z "$1" ]; then
        echo_info "$(_get_docker_compose) build\n"
        $(_get_docker_compose) build

        return 0
    fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then echo_danger "error: _docker_compose_build: \"$1\" file not found\n"; return 1; fi

    echo_info "$(_get_docker_compose) --file \"$1\" build\n"
    $(_get_docker_compose) --file "$1" build
}

