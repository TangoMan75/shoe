#!/bin/sh

## Create "traefik" network
network() {
    if [ ! -x "$(command -v docker)" ]; then
        echo_error "\"$(basename "${0}")\" requires docker, try 'sudo apt-get install -y docker.io'\n"
        return 1
    fi

    # following command will not break script execution on failure even with `-e` option enabled
    echo_info 'docker network create traefik || true\n'
    docker network create traefik || true
}

