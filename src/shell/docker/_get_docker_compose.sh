#!/bin/sh

# Return docker compose command
_get_docker_compose() {
    # Synopsis: _get_docker_compose

    if [ "$(docker compose 2>/dev/null)" ]; then
        echo 'docker compose'

        return 0
    fi

    if [ -x "$(command -v docker-compose)" ]; then
        echo 'docker-compose'

        return 0
    fi

    echo_danger "error: \"$(basename "${0}")\" requires docker-compose, try: 'sudo apt-get install -y docker-compose'\n"

    exit 1
}

