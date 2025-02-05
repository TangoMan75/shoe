#!/bin/sh

# Get container name from id
_get_container_name() {
    # Synopsis: _get_container_name <CONTAINER_ID>
    #   CONTAINER_ID: The container id.

    _check_installed docker

    if [ -z "$1" ]; then echo_danger 'error: _get_container_name: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _get_container_name: too many arguments (${#})\n"; return 1; fi

    docker inspect "$1" --format '{{slice .Name 1}}'
}

