#!/bin/sh

## Remove "traefik" network
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
network_remove() {
    _check_installed docker

    # following command will not break script execution on failure even with `-e` option enabled
    _echo_info 'docker network rm traefik || true\n'
    docker network rm traefik || true
}

