#!/bin/sh

## Build and start container stack
_start_docker() {
    # synopsys: _start_docker [working_directory]
    if [ ! -x "$(command -v docker-compose)" ]; then
        echo_danger "error: \"$0\" requires docker-compose\n"
        return 1
    fi

    if [ ${#} -lt 1 ]; then
        echo_danger 'error: some mandatory parameter is missing.\n'
        return 1
    fi

    if [ ! -d "$1" ]; then
        echo_danger "error: folder not found: \"$1\"\n"
        return 1
    fi

    (
        echo_info "cd \"$(dirname "$(realpath "$1")")\" || return 0\n"
        cd "$(dirname "$(realpath "$1")")" || return 0

        echo_info 'docker-compose up --detach --remove-orphans\n'
        docker-compose up --detach --remove-orphans
    )
}

