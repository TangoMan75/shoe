#!/bin/sh

## Create ".env.local" file
##
## @namespace recipes/tangoman.io/install
## @requires cp
## @depends recipes/tangoman.io/symfony/generate_app_secret.sh
## @depends src/shell/colors/_echo_info.sh
## @assumes env
set_env() {
    _echo_info "cp -f \".env.${env}\" .env.local\n"
    cp -f ".env.${env}" .env.local

    generate_app_secret
}

