#!/bin/sh

## Build and start traefik
##
## @namespace recipes/traefik/install
## @requires yq
## @depends recipes/traefik/app/password
## @depends recipes/traefik/certificates/certs
## @depends recipes/traefik/docker/build
## @depends recipes/traefik/docker/network
## @depends recipes/traefik/docker/start
## @depends recipes/traefik/install/set_env
## @depends recipes/traefik/letsencrypt/letsencrypt
## @depends src/shell/colors/_alert_secondary
## @depends src/shell/system/_check_installed
## @assumes env
up() {
    _alert_secondary "Starting Traefik container with \"${env}\" environment"
    _check_installed yq

    set_env

    if [ "${env}" = prod ]; then
        BASIC_AUTH="$(yq '.http.middlewares.auth.basicAuth.users' ./config/dynamic/dynamic.yaml)"
        if [ -z "${BASIC_AUTH}" ] || [ "${BASIC_AUTH}" = 'null' ] || [ "${BASIC_AUTH}" = '[]' ]; then
            password
        fi

        letsencrypt

    elif [ "${env}" = dev ]; then
        certs
    fi

    network
    build
    start
}

