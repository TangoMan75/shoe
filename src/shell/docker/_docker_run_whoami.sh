#!/bin/sh

## {
##   "namespace": "src/shell/docker",
##   "summary": "Run local whoami server",
##   "requires": [
##     "docker",
##     "whoami"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_check_installed"
##   ]
## }
_docker_run_whoami() {
    # Synopsis: _docker_run_whoami
    #   note: traefik_whoami documentation: https://github.com/traefik/whoami

    _check_installed docker

    if [ $# -gt 0 ]; then _echo_error "_docker_run_whoami: too many arguments ($#)\n"; return 1; fi

    _echo_info "docker run --detach --publish-all --rm --name whoami traefik/whoami\n"
    docker run --detach --publish-all --rm --name whoami traefik/whoami
}

