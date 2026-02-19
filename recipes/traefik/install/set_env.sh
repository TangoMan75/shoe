#!/bin/sh

## Set dev or prod configuration
##
## {
##   "namespace": "install",
##   "requires": [
##     "cp"
##   ],
##   "depends": [
##     "_echo_info"
##   ],
##   "assumes": [
##     "env"
##   ]
## }
set_env() {
    _overwrite=false
    if [ -f "./.env" ] || [ -f "./compose.yaml" ] || [ -f "./config/traefik.yaml" ] || [ -f "./config/dynamic/dynamic.yaml" ]; then
        if _yes_no 'Config file(s) already present, reset traefik ?'; then
            _overwrite=true
        fi
    fi

    if [ -f "./.env" ] && [ "${_overwrite}" = false ]; then
        _echo_warning "file \"./.env\" already present: skipping\n"
    else
        _echo_info "cp -f ./.env.${env}.dist ./.env\n"
        cp -f ./.env.${env}.dist ./.env
    fi

    if [ -f "./compose.yaml" ] && [ "${_overwrite}" = false ]; then
        _echo_warning "file \"./compose.yaml\" already present: skipping\n"
    else
        _echo_info "cp -f ./compose.${env}.yaml ./compose.yaml\n"
        cp -f ./compose.${env}.yaml ./compose.yaml
    fi

    if [ -f "./config/traefik.yaml" ] && [ "${_overwrite}" = false ]; then
        _echo_warning "file \"./config/traefik.yaml\" already present: skipping\n"
    else
        _echo_info "cp -f ./config/traefik.${env}.yaml ./config/traefik.yaml\n"
        cp -f ./config/traefik.${env}.yaml ./config/traefik.yaml
    fi

    if [ -f "./config/dynamic/dynamic.yaml" ] && [ "${_overwrite}" = false ]; then
        _echo_warning "file \"./config/dynamic/dynamic.yaml\" already present: skipping\n"
    else
        _echo_info "cp -f ./config/dynamic.${env}.yaml ./config/dynamic/dynamic.yaml\n"
        cp -f ./config/dynamic.${env}.yaml ./config/dynamic/dynamic.yaml
    fi
}

