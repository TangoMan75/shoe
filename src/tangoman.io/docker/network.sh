#!/bin/sh

## Create "traefik" network
network() {
    _check_installed docker

    # following command will not break script execution on failure even with `-e` option enabled
    echo_info 'docker network create traefik || true\n'
    docker network create traefik || true
}

