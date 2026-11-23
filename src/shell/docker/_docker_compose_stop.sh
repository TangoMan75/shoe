#!/bin/sh

## Stop container stack with docker compose
##
## @namespace src/shell/docker
## @requires realpath
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/docker/_docker_compose.sh
## @param {file} <FILE_PATH> The path to the compose.yaml file.
_docker_compose_stop() {
    if [ $# -gt 1 ]; then _echo_error "_docker_compose_stop: too many arguments ($#)\n"; return 1; fi

    if [ -z "$1" ]; then
        _echo_info "$(_docker_compose) stop\n"
        $(_docker_compose) stop

        return 0
    fi

    if [ ! -f "$1" ]; then _echo_error "_docker_compose_stop: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")"

    _echo_info "$(_docker_compose) --file \"$1\" stop\n"
    $(_docker_compose) --file "$1" stop
}

