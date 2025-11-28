#!/bin/sh

## Run script in Ubuntu Docker container
##
## {
##   "namespace": "app",
##   "requires": [
##     "docker"
##   ],
##   "depends": [
##     "_check_installed",
##     "_echo_info"
##   ]
## }
ubuntu() {
    _check_installed docker

    _echo_info "docker run -it --rm --volume=\"$(pwd):/home:ro\" --workdir=\"/home\" ubuntu sh entrypoint.sh\n"
    docker run -it --rm --volume="$(pwd):/home:ro" --workdir="/home" ubuntu sh entrypoint.sh
}

