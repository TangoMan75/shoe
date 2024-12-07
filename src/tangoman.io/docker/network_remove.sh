#!/bin/sh

## Remove "traefik" network
network_remove() {
    _check_installed docker

    # following command will not break script execution on failure even with `-e` option enabled
    echo_info 'docker network rm traefik || true\n'
    docker network rm traefik || true
}

