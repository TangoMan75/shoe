#!/bin/sh

## Run script in Ubuntu Docker container
ubuntu() {
    if [ ! -x "$(command -v docker)" ]; then
        echo_danger "error: \"$(basename "${0}")\" requires docker, try 'sudo apt-get install -y docker.io'\n"
        return 1
    fi

    echo_info "docker run -it --rm --volume=\"$(pwd):/home:ro\" --workdir=\"/home\" ubuntu sh entrypoint.sh\n"
    docker run -it --rm --volume="$(pwd):/home:ro" --workdir="/home" ubuntu sh entrypoint.sh
}

