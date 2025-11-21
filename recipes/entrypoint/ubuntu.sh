#!/bin/sh

## Run script in Ubuntu Docker container
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
ubuntu() {
    _check_installed docker

    echo_info "docker run -it --rm --volume=\"$(pwd):/home:ro\" --workdir=\"/home\" ubuntu sh entrypoint.sh\n"
    docker run -it --rm --volume="$(pwd):/home:ro" --workdir="/home" ubuntu sh entrypoint.sh
}

