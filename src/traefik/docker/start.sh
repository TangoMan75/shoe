#!/bin/sh

## Start docker stack
start() {
    echo_info 'docker compose up --detach --remove-orphans\n'
    docker compose up --detach --remove-orphans
}

