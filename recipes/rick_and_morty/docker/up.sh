#!/bin/sh

## {
##   "namespace": "recipes/rick_and_morty/docker",
##   "summary": "Create network, start container, composer install, import data, open in browser",
##   "requires": [
##     "basename",
##     "docker",
##     "open",
##     "php",
##     "sh"
##   ],
##   "depends": [
##     "recipes/rick_and_morty/docker/build",
##     "recipes/rick_and_morty/docker/network",
##     "recipes/rick_and_morty/docker/open",
##     "recipes/rick_and_morty/docker/start",
##     "src/shell/colors/_alert_primary",
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info"
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

