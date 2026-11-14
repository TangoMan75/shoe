#!/bin/sh

## Stop container stack with docker compose
##
## @namespace src/shell/docker
## @requires realpath
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/docker/_get_docker_compose
## @param {file} <FILE_PATH> The path to the compose.yaml file.
_docker_compose_stop() {
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

