#!/bin/sh

## Get container full name
container_name() {
    if [ ! -x "$(command -v docker)" ]; then
        echo_error "\"$(basename "${0}")\" requires docker, try 'sudo apt-get install -y docker.io'\n"
        return 1
    fi

    if [ -n "$1" ]; then
        container="$1"
    fi

    if [ -z "${container}" ]; then
        echo_error 'container name cannot be empty\n'
        return 1
    fi

    # sed to remove forbidden characters
    _project_name=$(basename "$(pwd)" | sed 's/[^a-zA-Z0-9_-]//g')

    # get container names
    # shellcheck disable=SC2046
    docker inspect --format '{{slice .Name 1}}' $(docker ps --all --quiet) | grep "${_project_name}" | grep "${container}" | head -n1

    # get container names withg docker compose
    # docker compose ps --format '{{.Name}}' | grep "${_project_name}" | grep "${container}" | head -n1
}

