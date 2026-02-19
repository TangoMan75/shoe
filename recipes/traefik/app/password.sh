#!/bin/sh

## Set traefik dashboard password
##
## {
##   "namespace": "app",
##   "requires": [
##     "htpasswd",
##     "read",
##     "yq"
##   ],
##   "depends": [
##     "_check_installed",
##     "_echo_info",
##     "_echo_success",
##     "_get_parameter",
##     "_set_parameter"
##   ]
## }
password() {
    _check_installed htpasswd
    _check_installed yq

    # command-line option takes precedence over environment variable
    if [ -n "${user}" ]; then
        TRAEFIK_USER="${user}"
    fi

    # environment variable take precedence over config file
    if [ -z "${TRAEFIK_USER}" ]; then
        TRAEFIK_USER="$(_get_parameter .env TRAEFIK_USER)"
    fi

    # default fallback to user prompt
    while [ -z "${TRAEFIK_USER}" ]; do
        _echo_success 'Choose dashboard username (eg: root): '
        read -r TRAEFIK_USER
    done

    _set_parameter .env TRAEFIK_USER "\"${TRAEFIK_USER}\""

    # command-line option takes precedence over environment variable
    if [ -n "${password}" ]; then
        TRAEFIK_PASSWORD="${password}"
    fi

    # environment variable take precedence over config file
    if [ -z "${TRAEFIK_PASSWORD}" ]; then
        TRAEFIK_PASSWORD="$(_get_parameter .env TRAEFIK_PASSWORD)"
    fi

    # default fallback to user prompt
    while [ -z "${TRAEFIK_PASSWORD}" ]; do
        _echo_success 'Choose dashboard password (eg: toor): '
        read -r TRAEFIK_PASSWORD
    done

    _set_parameter .env TRAEFIK_PASSWORD "\"${TRAEFIK_PASSWORD}\""

    _encrypted_password=$(htpasswd -nb "${TRAEFIK_USER}" "${TRAEFIK_PASSWORD}")

    if [ -f ./config/dynamic/dynamic.yaml ]; then
        _echo_info "TRAEFIK_PASSWORD=\"${_encrypted_password}\" yq -i '.http.middlewares.auth.basicAuth.users = [strenv(TRAEFIK_PASSWORD)]' ./config/dynamic/dynamic.yaml\n"
        TRAEFIK_PASSWORD="${_encrypted_password}" yq -i '.http.middlewares.auth.basicAuth.users = [strenv(TRAEFIK_PASSWORD)]' ./config/dynamic/dynamic.yaml
    fi
}

