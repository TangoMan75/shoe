#!/bin/sh

## Set dev or prod environment
set_env() {
    echo_info "cp -f ./.env.${env}.dist ./.env\n"
    cp -f ./.env.${env}.dist ./.env

    echo_info "cp -f ./compose.${env}.yaml ./compose.yaml\n"
    cp -f ./compose.${env}.yaml ./compose.yaml

    echo_info "cp -f ./config/traefik.${env}.yaml ./config/traefik.yaml\n"
    cp -f ./config/traefik.${env}.yaml ./config/traefik.yaml

    echo_info "cp -f ./config/dynamic.${env}.yaml ./config/dynamic/dynamic.yaml\n"
    cp -f ./config/dynamic.${env}.yaml ./config/dynamic/dynamic.yaml
}

