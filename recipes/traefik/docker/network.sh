#!/bin/sh

## Create network
##
## {
##   "namespace": "docker",
##   "requires": [
##     "docker",
##     "read",
##     "yq"
##   ],
##   "depends": [
##     "_echo_info",
##     "_echo_success",
##     "_get_parameter",
##     "_set_parameter"
##   ]
## }
network() {
    _check_installed docker
    _check_installed yq

    # command-line option takes precedence over environment variable
    if [ -n "${network}" ]; then
        TRAEFIK_NETWORK="${network}"
    fi

    # environment variable take precedence over config file
    if [ -z "${TRAEFIK_NETWORK}" ]; then
        TRAEFIK_NETWORK="$(_get_parameter .env TRAEFIK_NETWORK)"
    fi

    # default fallback to user prompt
    if [ -z "${TRAEFIK_NETWORK}" ]; then
        _echo_success 'Enter traefik network name : [traefik] '
        user_prompt=''
        read -r user_prompt
        if [ -z "${user_prompt}" ]; then
            TRAEFIK_NETWORK=traefik
        else
            TRAEFIK_NETWORK="${user_prompt}"
        fi
    fi

    _set_parameter .env TRAEFIK_NETWORK "\"${TRAEFIK_NETWORK}\""

    _echo_info "docker network create \"${TRAEFIK_NETWORK}\" || true\n"
    docker network create "${TRAEFIK_NETWORK}" || true

    _echo_info "TRAEFIK_NETWORK=\"${TRAEFIK_NETWORK}\" yq -i '.services[].networks = [strenv(TRAEFIK_NETWORK)]' \"./compose.yaml\"\n"
    TRAEFIK_NETWORK="${TRAEFIK_NETWORK}" yq -i '.services[].networks = [strenv(TRAEFIK_NETWORK)]' "./compose.yaml"

    _echo_info "yq -i '.networks = null' \"./compose.yaml\"\n"
    yq -i '.networks = null' "./compose.yaml"

    _echo_info "TRAEFIK_NETWORK=\"${TRAEFIK_NETWORK}\" yq -i '.networks.[strenv(TRAEFIK_NETWORK)].external = true' \"./compose.yaml\"\n"
    TRAEFIK_NETWORK="${TRAEFIK_NETWORK}" yq -i '.networks.[strenv(TRAEFIK_NETWORK)].external = true' "./compose.yaml"
}

