#!/bin/sh

## Remove images
images_remove() {
    _check_installed docker

    echo_info "docker rm \"$(container_name nginx)\" || true\n"
    docker rm "$(container_name nginx)" || true

    echo_info "docker rm \"$(container_name php)\" || true\n"
    docker rm "$(container_name php)" || true
}

