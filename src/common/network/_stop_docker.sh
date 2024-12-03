#!/bin/sh

# Stop container stack
_stop_docker() {
    # Synopsis: _stop_docker WORKING_DIRECTORY
    if [ ! -x "$(command -v docker-compose)" ]; then
        echo_danger "error: \"$0\" requires docker-compose\n"
        return 1
    fi

    if [ ${#} -lt 1 ]; then echo_danger 'error: _stop_docker: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _stop_docker: too many arguments (${#})\n"; exit 1; fi

    if [ ! -d "$1" ]; then
        echo_danger "error: _stop_docker: folder not found: \"$1\"\n"
        return 1
    fi

    (
        echo_info "cd \"$(dirname "$(realpath "$1")")\" || return 0\n"
        cd "$(dirname "$(realpath "$1")")" || return 0

        echo_info 'docker-compose stop\n'
        docker-compose stop
    )
}

