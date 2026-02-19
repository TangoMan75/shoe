#!/bin/sh

## Uninstall Traefik
##
## {
##   "namespace": "install",
##   "requires": [
##     "docker",
##     "rm"
##   ],
##   "depends": [
##     "_echo_info",
##     "_echo_warning",
##     "_yes_no",
##     "clear",
##     "remove_certs",
##     "remove_network"
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

