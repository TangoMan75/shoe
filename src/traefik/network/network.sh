#!/bin/sh

## Create network
network() {
    if [ -z "${network}" ]; then
        echo_success 'Enter network name : [traefik] '
        USER_PROMPT=''
        read -r USER_PROMPT
        if [ -z "${USER_PROMPT}" ]; then
            network=traefik
        else
            network="${USER_PROMPT}"
        fi
    fi

    echo_info "docker network create \"${network}\" || true\n"
    docker network create "${network}" || true

    echo_info "NETWORK=\"${network}\" yq -i '.services[].networks = [strenv(NETWORK)]' \"./compose.yaml\"\n"
    NETWORK="${network}" yq -i '.services[].networks = [strenv(NETWORK)]' "./compose.yaml"

    echo_info "yq -i '.networks = null' \"./compose.yaml\"\n"
    yq -i '.networks = null' "./compose.yaml"

    echo_info "NETWORK=\"${network}\" yq -i '.networks.[strenv(NETWORK)].external = true' \"./compose.yaml\"\n"
    NETWORK="${network}" yq -i '.networks.[strenv(NETWORK)].external = true' "./compose.yaml"
}

