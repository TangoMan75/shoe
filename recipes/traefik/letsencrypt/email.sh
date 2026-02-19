#!/bin/sh

## Set Let's Encrypt email
##
## {
##   "namespace": "letsencrypt",
##   "requires": [
##     "read",
##     "yq"
##   ],
##   "depends": [
##     "_echo_info",
##     "_echo_success",
##     "_get_parameter",
##     "requirements"
##   ]
## }
email() {
    _check_installed yq

    # command-line option takes precedence over environment variable
    if [ -n "${email}" ]; then
        TRAEFIK_EMAIL="${email}"
    fi

    # environment variable take precedence over config file
    if [ -z "${TRAEFIK_EMAIL}" ]; then
        TRAEFIK_EMAIL="$(_get_parameter .env TRAEFIK_EMAIL)"
    fi

    # default fallback to user prompt
    while [ -z "${TRAEFIK_EMAIL}" ]; do
        _echo_success "Enter let's encrypt email (eg: admin@yopmail.com): "
        read -r TRAEFIK_EMAIL
    done

    _set_parameter .env TRAEFIK_EMAIL "\"${TRAEFIK_EMAIL}\""

    _echo_info "TRAEFIK_EMAIL=\"${TRAEFIK_EMAIL}\" yq -i '.certificatesResolvers.letsencrypt.acme.email = strenv(TRAEFIK_EMAIL)' ./config/traefik.yaml\n"
    TRAEFIK_EMAIL="${TRAEFIK_EMAIL}" yq -i '.certificatesResolvers.letsencrypt.acme.email = strenv(TRAEFIK_EMAIL)' ./config/traefik.yaml
}

