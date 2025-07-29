#!/bin/sh

# Run local whoami server
_docker_run_whoami() {
    # Synopsis: _docker_run_whoami
    #   note: traefik_whoami documentation: https://github.com/traefik/whoami

    _check_installed docker

    if [ ${#} -gt 0 ]; then echo_danger "error: _docker_run_whoami: too many arguments (${#})\n"; return 1; fi

    echo_info "docker run --detach --publish-all --rm --name whoami traefik/whoami\n"
    docker run --detach --publish-all --rm --name whoami traefik/whoami
}

