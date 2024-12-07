#!/bin/sh

## Restore traefik configuration
restore() {
    echo_info 'cp ~/.TangoMan75/traefik/.env ./ || true\n'
    cp ~/.TangoMan75/traefik/.env ./ || true

    echo_info 'cp ~/.TangoMan75/traefik/acme.json ./config || true\n'
    cp ~/.TangoMan75/traefik/acme.json ./config || true

    echo_info 'cp ~/.TangoMan75/traefik/compose.yaml ./ || true\n'
    cp ~/.TangoMan75/traefik/compose.yaml ./ || true

    echo_info 'cp ~/.TangoMan75/traefik/traefik.yaml ./ || true\n'
    cp ~/.TangoMan75/traefik/traefik.yaml ./ || true
}

