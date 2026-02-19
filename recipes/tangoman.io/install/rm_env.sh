#!/bin/sh

## Remove ".env.local" and ".env.dev.local" files
##
## {
##   "namespace": "install",
##   "depends": [
##     "_echo_info"
##   ]
## }
rm_env() {
    _echo_info "rm -f .env.local\n"
    rm -f .env.local

    _echo_info "rm -f .env.dev.local\n"
    rm -f .env.dev.local
}

