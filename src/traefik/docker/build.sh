#!/bin/sh

## Build docker stack
build() {
    echo_info 'docker compose build\n'
    docker compose build
}

