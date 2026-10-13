#!/bin/sh

## {
##   "namespace": "src/shell/docker",
##   "summary": "Kill all running containers with docker",
##   "requires": [
##     "docker",
##     "kill",
##     "ps",
##     "tr"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_check_installed"
##   ]
## }
_docker_kill_all() {
    # Synopsis: _docker_kill_all

    _check_installed docker

    _echo_info "docker kill $(docker ps --quiet --format '{{.Names}}' | tr -s "\n" ' ')\n"
    # shellcheck disable=SC2046
    docker kill $(docker ps --quiet --format '{{.Names}}')
}

