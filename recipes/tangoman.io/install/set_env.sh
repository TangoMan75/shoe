#!/bin/sh

## Create ".env.local" file
##
## {
##   "namespace": "install",
##   "depends": [
##     "_echo_info",
##     "generate_app_secret"
##   ]
## }
set_env() {
    _echo_info "cp -f .env.${env} .env.local\n"
    cp -f .env.${env} .env.local

    generate_app_secret
}

