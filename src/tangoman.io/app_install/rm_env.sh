#!/bin/sh

## Remove ".env.local" and ".env.dev.local" files
rm_env() {
    echo_info "rm -f .env.local\n"
    rm -f .env.local

    echo_info "rm -f .env.dev.local\n"
    rm -f .env.dev.local
}

