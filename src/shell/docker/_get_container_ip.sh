#!/bin/sh

# Get running container ip
_get_container_ip() {
    # Synopsis: _get_container_ip <CONTAINER_NAME|CONTAINER_ID>
    #   CONTAINER_NAME:  The name of the docker container.
    #   CONTAINER_ID:    The id of the docker container.

    _check_installed docker

    if [ -z "$1" ]; then echo_danger 'error: _get_container_ip: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _get_container_ip: too many arguments (${#})\n"; return 1; fi

    docker inspect "$1" --format '{{range .NetworkSettings.Networks}}{{if .IPAddress}}{{.IPAddress}}{{end}}{{end}}' 2>/dev/null
}

