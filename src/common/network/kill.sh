#!/bin/sh

## Kill all runnnig containers
kill() {
    if [ ! -x "$(command -v docker)" ]; then
        echo_danger "error: \"$0)\" requires docker, try 'sudo apt-get install -y docker.io'\n"
        return 1
    fi

    if [ -z "$(docker ps --quiet)" ]; then
        echo_warning 'no container running.\n'
        return 0
    fi

    echo_info "docker kill $(docker ps --quiet --format '{{.Names}}' | tr -s "\n" ' ')\n"
    # shellcheck disable=SC2046
    docker kill $(docker ps --quiet --format '{{.Names}}')
}

