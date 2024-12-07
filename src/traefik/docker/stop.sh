#!/bin/sh

## Stop docker stack
stop() {
    echo_info 'docker compose stop || true\n'
    docker compose stop || true
}

