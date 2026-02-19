#!/bin/sh

## {
##   "namespace": "recipes/rick_and_morty/docker",
##   "summary": "Remove \"traefik\" network",
##   "requires": [
##     "docker",
##     "rm",
##     "true"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_check_installed"
##   ]
## }
network_remove() {
    _check_installed docker

    # following command will not break script execution on failure even with `-e` option enabled
    _echo_info 'docker network rm traefik || true\n'
    docker network rm traefik || true
}

