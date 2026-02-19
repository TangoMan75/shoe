#!/bin/sh

## Build and start traefik
##
## {
##   "namespace": "install",
##   "requires": [
##     "yq"
##   ],
##   "depends": [
##     "_alert_secondary",
##     "build",
##     "certs",
##     "letsencrypt",
##     "network",
##     "password",
##     "set_env",
##     "start"
##   ],
##   "assumes": [
##     "env"
##   ]
## }
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

