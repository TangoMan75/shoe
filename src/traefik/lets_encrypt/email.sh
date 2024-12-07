#!/bin/sh

## Set Let's Encrypt email
email() {
    if [ ! -x "$(command -v yq)" ]; then
        echo_error "\"$(basename "${0}")\" requires yq\n"
        exit 1
    fi

    if [ -z "${email}" ]; then
        USER_PROMPT=''
        while [ -z "${USER_PROMPT}" ]; do
            echo_success 'Enter admin email (eg: admin@yopmail.com): '
            read -r USER_PROMPT
        done
    fi

    echo_info "EMAIL=\"${USER_PROMPT}\" yq -i '.certificatesResolvers.letsencrypt.acme.email = strenv(EMAIL)' ./config/traefik.yaml\n"
    EMAIL="${USER_PROMPT}" yq -i '.certificatesResolvers.letsencrypt.acme.email = strenv(EMAIL)' ./config/traefik.yaml
}

