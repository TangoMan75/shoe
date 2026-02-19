#!/bin/sh

## {
##   "namespace": "recipes/traefik/letsencrypt",
##   "summary": "Set Let's Encrypt email",
##   "requires": [
##     "read",
##     "yq"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/colors/_echo_success",
##     "src/shell/reflexion/_get_parameter",
##     "src/shell/reflexion/_set_parameter",
##     "src/shell/system/_check_installed"
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

