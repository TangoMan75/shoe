#!/bin/sh

## Set traefik dashboard password
password() {
    if [ -z "${user}" ]; then
        USER_PROMPT=''
        while [ -z "${USER_PROMPT}" ]; do
            echo_success 'Enter username (eg: root): '
            read -r USER_PROMPT
        done
        user="${USER_PROMPT}"
    fi

    if [ -z "${password}" ]; then
        USER_PROMPT=''
        while [ -z "${USER_PROMPT}" ]; do
            echo_success 'Enter password (eg: toor): '
            read -r USER_PROMPT
        done
        password="${USER_PROMPT}"
    fi

    _encrypted_password=$(htpasswd -nb "${user}" "${password}")

    if [ -f ./config/dynamic/dynamic.yaml ]; then
        echo_info "PASSWORD=\"${_encrypted_password}\" yq -i '.http.middlewares.auth.basicAuth.users = [strenv(PASSWORD)]' ./config/dynamic/dynamic.yaml\n"
        PASSWORD="${_encrypted_password}" yq -i '.http.middlewares.auth.basicAuth.users = [strenv(PASSWORD)]' ./config/dynamic/dynamic.yaml
    fi
}

