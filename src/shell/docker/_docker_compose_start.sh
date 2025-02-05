#!/bin/sh

# Build and start container stack with docker compose
_docker_compose_start() {
    # Synopsis: _docker_compose_start <FILE_PATH>
    #   FILE_PATH: The path to the compose.yaml file.

    if [ -z "$1" ]; then echo_danger 'error: _docker_compose_start: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _docker_compose_start: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then echo_danger "error: _docker_compose_start: \"$1\" file not found\n"; return 1; fi

    echo_info "$(_get_docker_compose) --file \"$1\" up --detach --remove-orphans\n"
    $(_get_docker_compose) --file "$1" up --detach --remove-orphans
}

