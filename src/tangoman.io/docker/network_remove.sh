#!/bin/sh

## Remove "traefik" network
network_remove() {
    if [ ! -x "$(command -v docker)" ]; then
        echo_error "\"$(basename "${0}")\" requires docker, try 'sudo apt-get install -y docker.io'\n"
        return 1
    fi

    # following command will not break script execution on failure even with `-e` option enabled
    echo_info 'docker network rm traefik || true\n'
    docker network rm traefik || true
}

