#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/docker",
##   "summary": "Create \"traefik\" network",
##   "requires": [
##     "docker",
##     "true"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_check_installed"
##   ]
## }
network() {
    _check_installed docker

    # following command will not break script execution on failure even with `-e` option enabled
    _echo_info 'docker network create traefik || true\n'
    docker network create traefik || true
}

