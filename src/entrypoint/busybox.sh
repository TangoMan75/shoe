#!/bin/sh

## Run script in Busybox Docker container
busybox() {
    if [ ! -x "$(command -v docker)" ]; then
        echo_danger "error: \"$(basename "${0}")\" requires docker, try 'sudo apt-get install -y docker.io'\n"
        return 1
    fi

    echo_info "docker run -it --rm --volume=\"$(pwd):/home:ro\" --workdir=\"/home\" busybox sh entrypoint.sh\n"
    docker run -it --rm --volume="$(pwd):/home:ro" --workdir="/home" busybox sh entrypoint.sh
}

