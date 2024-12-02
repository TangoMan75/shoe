#!/bin/sh

# Build and start container stack
_start_docker() {
    # Synopsis: _start_docker WORKING_DIRECTORY
    if [ ! -x "$(command -v docker-compose)" ]; then
        echo_danger "error: \"$0\" requires docker-compose\n"
        return 1
    fi

    if [ ${#} -lt 1 ]; then echo_danger 'error: _start_docker: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _start_docker: too many arguments (${#})\n"; exit 1; fi

    if [ ! -d "$1" ]; then
        echo_danger "error: _start_docker: folder not found: \"$1\"\n"
        return 1
    fi

    (
        echo_info "cd \"$(dirname "$(realpath "$1")")\" || return 0\n"
        cd "$(dirname "$(realpath "$1")")" || return 0

        echo_info 'docker-compose up --detach --remove-orphans\n'
        docker-compose up --detach --remove-orphans
    )
}

