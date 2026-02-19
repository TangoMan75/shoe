#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/docker",
##   "summary": "Remove images",
##   "requires": [
##     "docker",
##     "php",
##     "rm",
##     "true"
##   ],
##   "depends": [
##     "recipes/tangoman.io/docker/container_name",
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_check_installed"
##   ]
## }
images_remove() {
    _check_installed docker

    _echo_info "docker rm \"$(container_name nginx)\" || true\n"
    docker rm "$(container_name nginx)" || true

    _echo_info "docker rm \"$(container_name php)\" || true\n"
    docker rm "$(container_name php)" || true
}

