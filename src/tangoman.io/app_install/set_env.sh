#!/bin/sh

## Create ".env.local" file
set_env() {
    echo_info "cp -f .env.${env} .env.local\n"
    cp -f .env.${env} .env.local

    generate_app_secret
}

