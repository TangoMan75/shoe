#!/bin/sh

## Create "traefik" network
##
## {
##   "namespace": "docker",
##   "requires": [
##     "docker"
##   ],
##   "depends": [
##     "_check_installed",
##     "_echo_info"
##   ]
## }
network() {
    _check_installed docker

    # following command will not break script execution on failure even with `-e` option enabled
    _echo_info 'docker network create traefik || true\n'
    docker network create traefik || true
}

