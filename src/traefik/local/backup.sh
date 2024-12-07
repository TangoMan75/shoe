#!/bin/sh

## Backup traefik configuration
backup() {
    if [ ! -d ~/.TangoMan75/traefik ]; then
        echo_info 'mkdir -p ~/.TangoMan75/traefik\n'
        mkdir -p ~/.TangoMan75/traefik
    fi

    echo_info 'cp ./.env ~/.TangoMan75/traefik || true\n'
    cp ./.env ~/.TangoMan75/traefik || true

    echo_info 'cp ./compose.yaml ~/.TangoMan75/traefik || true\n'
    cp ./compose.yaml ~/.TangoMan75/traefik || true

    echo_info 'cp ./config/acme.json ~/.TangoMan75/traefik || true\n'
    cp ./config/acme.json ~/.TangoMan75/traefik || true

    echo_info 'cp ./config/traefik.yaml ~/.TangoMan75/traefik || true\n'
    cp ./config/traefik.yaml ~/.TangoMan75/traefik || true
}

