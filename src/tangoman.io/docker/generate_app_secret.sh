#!/bin/sh

## Generate APP_SECRET
generate_app_secret() {
    if [ ! -x "$(command -v openssl)" ]; then
        echo_error "\"$(basename "${0}")\" requires openssl, try 'sudo apt-get install -y openssl'\n"
        return 1
    fi

    if [ -f .env.local ]; then
        echo_info "sed -i -r \"/APP_SECRET=/s/[a-z0-9]+/\$(openssl rand -hex 16)/\" \".env.local\"\n"
        sed -i -r "/APP_SECRET=/s/[a-z0-9]+/$(openssl rand -hex 16)/" ".env.local"
    fi
}

