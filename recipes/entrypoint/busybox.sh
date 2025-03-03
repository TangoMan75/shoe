#!/bin/sh

## Run script in Busybox Docker container
##
## {
##   "requires": [
##     "docker"
##   ],
##   "depends": [
##     "_check_installed",
##     "echo_info"
##   ]
## }
busybox() {
    _check_installed docker

    echo_info "docker run -it --rm --volume=\"$(pwd):/home:ro\" --workdir=\"/home\" busybox sh entrypoint.sh\n"
    docker run -it --rm --volume="$(pwd):/home:ro" --workdir="/home" busybox sh entrypoint.sh
}

