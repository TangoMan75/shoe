#!/bin/sh

## {
##   "namespace": "recipes/traefik/install",
##   "summary": "Build and start traefik",
##   "requires": [
##     "yq"
##   ],
##   "depends": [
##     "recipes/agnostic-companion/docker/start",
##     "recipes/agnostic-companion/install/set_env",
##     "recipes/calculatrice-salaire-net/app/build",
##     "recipes/rick_and_morty/docker/network",
##     "recipes/traefik/app/password",
##     "recipes/traefik/certificates/certs",
##     "recipes/traefik/letsencrypt/letsencrypt",
##     "src/shell/colors/_alert_secondary",
##     "src/shell/system/_check_installed"
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

