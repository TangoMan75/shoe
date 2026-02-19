#!/bin/sh

## Generate APP_SECRET
##
## {
##   "namespace": "symfony",
##   "requires": [
##     "openssl",
##     "sed"
##   ],
##   "depends": [
##     "_check_installed",
##     "_echo_info"
##   ]
## }
generate_app_secret() {
    _check_installed openssl

    if [ -f .env.local ]; then
        _echo_info "sed -i -r \"/APP_SECRET=/s/[a-z0-9]+/\$(openssl rand -hex 16)/\" \".env.local\"\n"
        sed -i -r "/APP_SECRET=/s/[a-z0-9]+/$(openssl rand -hex 16)/" ".env.local"
    fi
}

