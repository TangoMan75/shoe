#!/bin/sh

## Build and start traefik
up() {
    alert_secondary "Starting Traefik with \"${env}\" environment"

    requirements
    # shellcheck disable=SC2181
    if [ "$?" -ne 0 ]; then
        return 1;
    fi

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

