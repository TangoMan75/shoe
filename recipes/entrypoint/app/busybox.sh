#!/bin/sh

## {
##   "namespace": "recipes/entrypoint/app",
##   "summary": "Run script in Busybox Docker container",
##   "requires": [
##     "docker",
##     "sh"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_check_installed"
##   ]
## }
busybox() {
    _check_installed docker

    _echo_info "docker run -it --rm --volume=\"$(pwd):/home:ro\" --workdir=\"/home\" busybox sh entrypoint.sh\n"
    docker run -it --rm --volume="$(pwd):/home:ro" --workdir="/home" busybox sh entrypoint.sh
}

