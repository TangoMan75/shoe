#!/bin/sh

## Create network, start container, composer install, import data, open in browser
##
## {
##   "namespace": "docker",
##   "requires": [
##     "docker"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_info",
##     "build",
##     "network",
##     "open",
##     "start"
##   ]
## }
up() {
    _alert_primary "Spawning project with \"${env}\" environment"

    if [ -z "$(docker compose -v)" ]; then
        _echo_error "\"$(basename "${0}")\" requires docker compose plugin\n"
        return 1
    fi

    network
    build
    start

    _echo_info "docker compose --file \"./compose.${env}.yaml\" exec php sh -c \"sh entrypoint.sh install --env ${env}\"\n"
    docker compose --file "./compose.${env}.yaml" exec php sh -c "sh entrypoint.sh install --env ${env}"

    _echo_info "docker compose --file \"./compose.${env}.yaml\" exec php sh -c \"sh entrypoint.sh import_data --env ${env}\"\n"
    docker compose --file "./compose.${env}.yaml" exec php sh -c "sh entrypoint.sh import_data --env ${env}"

    open
}

