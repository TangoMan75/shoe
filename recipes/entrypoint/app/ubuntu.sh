#!/bin/sh

## {
##   "namespace": "recipes/entrypoint/app",
##   "summary": "Run script in Ubuntu Docker container",
##   "requires": [
##     "docker",
##     "sh"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_check_installed"
##   ]
## }
ubuntu() {
    _check_installed docker

    _echo_info "docker run -it --rm --volume=\"$(pwd):/home:ro\" --workdir=\"/home\" ubuntu sh entrypoint.sh\n"
    docker run -it --rm --volume="$(pwd):/home:ro" --workdir="/home" ubuntu sh entrypoint.sh
}

