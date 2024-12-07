#!/bin/sh

## Uninstall Traefik
uninstall() {
    stop

    echo_info 'docker rm traefik || true\n'
    docker rm traefik || true

    echo_info 'docker rm whoami || true\n'
    docker rm whoami || true

    echo_warning 'Remove network ? (yes/no) : [no] '
    USER_PROMPT=''
    read -r USER_PROMPT
    if [ "${USER_PROMPT}" = 'yes' ]; then
        remove_network
    fi

    remove_certs
    clear

    echo_info "rm -f ./.env\n"
    rm -f ./.env

    echo_info 'rm -f ./compose.yaml\n'
    rm -f ./compose.yaml

    echo_info 'rm -f ./config/traefik.yaml\n'
    rm -f ./config/traefik.yaml

    echo_info 'rm -f ./config/dynamic/dynamic.yaml\n'
    rm -f ./config/dynamic/dynamic.yaml

}

