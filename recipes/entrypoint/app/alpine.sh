#!/bin/sh

## {
##   "namespace": "recipes/entrypoint/app",
##   "summary": "Run script in Alpine Docker container",
##   "requires": [
##     "docker",
##     "pwd",
##     "sh"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_check_installed"
##   ]
## }
alpine() {
    _check_installed docker

    _echo_info "docker run -it --rm --volume=\"$(pwd):/home:ro\" --workdir=\"/home\" alpine sh entrypoint.sh\n"
    docker run -it --rm --volume="$(pwd):/home:ro" --workdir="/home" alpine sh entrypoint.sh
}

