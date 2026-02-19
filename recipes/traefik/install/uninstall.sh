#!/bin/sh

## {
##   "namespace": "recipes/traefik/install",
##   "summary": "Uninstall Traefik",
##   "requires": [
##     "clear",
##     "docker",
##     "rm",
##     "true",
##     "whoami"
##   ],
##   "depends": [
##     "recipes/traefik/app/clear",
##     "recipes/traefik/certificates/remove_certs",
##     "recipes/traefik/docker/remove_network",
##     "recipes/traefik/docker/stop",
##     "src/shell/colors/_echo_info",
##     "src/shell/install/_uninstall",
##     "src/shell/prompts/_yes_no",
##     "src/shell/reflexion/_get_parameter",
##     "src/shell/system/_check_installed"
##   ]
## }
uninstall() {
    _check_installed docker

    stop

    _echo_info 'docker rm traefik || true\n'
    docker rm traefik || true

    _echo_info 'docker rm whoami || true\n'
    docker rm whoami || true

    # command-line option takes precedence over environment variable
    if [ -n "${network}" ]; then
        TRAEFIK_NETWORK="${network}"
    fi

    # environment variable take precedence over config file
    if [ -z "${TRAEFIK_NETWORK}" ]; then
        TRAEFIK_NETWORK="$(_get_parameter .env TRAEFIK_NETWORK)"
    fi

    if _yes_no "Remove \"${TRAEFIK_NETWORK}\" network ?"; then
        remove_network
    fi

    remove_certs
    clear

    _echo_info "rm -f ./.env\n"
    rm -f ./.env

    _echo_info 'rm -f ./compose.yaml\n'
    rm -f ./compose.yaml

    _echo_info 'rm -f ./config/traefik.yaml\n'
    rm -f ./config/traefik.yaml

    _echo_info 'rm -f ./config/dynamic/dynamic.yaml\n'
    rm -f ./config/dynamic/dynamic.yaml

    _uninstall "$0"
}

