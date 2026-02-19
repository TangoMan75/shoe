#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/docker",
##   "summary": "Shell into \"php\" container",
##   "requires": [
##     "basename",
##     "clear",
##     "docker",
##     "php",
##     "sh"
##   ],
##   "depends": [
##     "recipes/traefik/app/clear",
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info"
##   ]
## }
shell() {
    if [ -z "$(docker compose -v)" ]; then
        _echo_error "\"$(basename "${0}")\" requires docker compose plugin\n"
        return 1
    fi

    clear
    _echo_info 'docker compose exec -it php sh\n'
    docker compose exec -it php sh
}

