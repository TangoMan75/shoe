#!/bin/sh

## Shell into "php" container
##
## {
##   "namespace": "docker",
##   "requires": [
##     "docker"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_info",
##     "clear"
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

