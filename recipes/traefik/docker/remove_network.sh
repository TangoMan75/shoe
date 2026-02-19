#!/bin/sh

## {
##   "namespace": "recipes/traefik/docker",
##   "summary": "Remove network",
##   "requires": [
##     "docker",
##     "rm",
##     "true"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/reflexion/_get_parameter",
##     "src/shell/system/_check_installed"
##   ]
## }
remove_network() {
    _check_installed docker

    # command-line option takes precedence over environment variable
    if [ -n "${network}" ]; then
        TRAEFIK_NETWORK="${network}"
    fi

    # environment variable take precedence over config file
    if [ -z "${TRAEFIK_NETWORK}" ]; then
        TRAEFIK_NETWORK="$(_get_parameter .env TRAEFIK_NETWORK)"
    fi

    _echo_info "docker network rm \"${TRAEFIK_NETWORK}\" || true\n"
    docker network rm "${TRAEFIK_NETWORK}" || true
}

