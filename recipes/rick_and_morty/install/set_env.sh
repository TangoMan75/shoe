#!/bin/sh

## Create ".env.local" file
##
## @namespace recipes/rick_and_morty/install
## @requires cp
## @depends recipes/rick_and_morty/symfony/generate_app_secret src/shell/colors/_echo_info
## @assumes env
set_env() {
    _echo_info "cp -f .env.${env} .env.local\n"
    cp -f .env.${env} .env.local

    generate_app_secret
}

