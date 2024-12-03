#!/bin/sh

## Remove images
images_remove() {
    if [ ! -x "$(command -v docker)" ]; then
        echo_error "\"$(basename "${0}")\" requires docker, try 'sudo apt-get install -y docker.io'\n"
        return 1
    fi

    echo_info "docker rm \"$(container_name nginx)\" || true\n"
    docker rm "$(container_name nginx)" || true

    echo_info "docker rm \"$(container_name php)\" || true\n"
    docker rm "$(container_name php)" || true
}

