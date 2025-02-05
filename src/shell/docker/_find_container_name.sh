#!/bin/sh

# Find container name from string
_find_container_name() {
    # Synopsis: _find_container_name <STRING>
    #   STRING: The string to find among running containers.

    _check_installed docker

    if [ -z "$1" ]; then echo_danger 'error: _find_container_name: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _find_container_name: too many arguments (${#})\n"; return 1; fi

    # sanitize input
    set -- "$(printf '%s' "$1" | sed 's/[^a-zA-Z0-9_-]//g')"

    # get container names
    # shellcheck disable=SC2046
    docker inspect --format '{{slice .Name 1}}' $(docker ps --all --quiet) | grep "$1" | head -n1
}

