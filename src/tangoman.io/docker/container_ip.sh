#!/bin/sh

## Get running container ip
container_ip() {
    _check_installed docker

    if [ -n "$1" ]; then
        container="$1"
    fi

    if [ -z "${container}" ]; then
        echo_error 'container name cannot be empty\n'
        return 1
    fi

    docker inspect "$(container_name "${container}")" --format '{{range .NetworkSettings.Networks}}{{if .IPAddress}}{{.IPAddress}}{{end}}{{end}}' 2>/dev/null
}

