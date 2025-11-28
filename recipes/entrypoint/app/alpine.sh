#!/bin/sh

## Run script in Alpine Docker container
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
alpine() {
    _check_installed docker

    _echo_info "docker run -it --rm --volume=\"$(pwd):/home:ro\" --workdir=\"/home\" alpine sh entrypoint.sh\n"
    docker run -it --rm --volume="$(pwd):/home:ro" --workdir="/home" alpine sh entrypoint.sh
}

