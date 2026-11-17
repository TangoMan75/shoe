#!/bin/sh

## Copy ".env" from ".env.dist" file
##
## @namespace recipes/agnostic-companion/install
## @requires cp
## @depends src/shell/colors/_echo_info
set_env() {
    # do not overwrite
    if [ -f .env ]; then
        return 0
    fi

    _echo_info "cp -f .env.dist .env\n"
    cp -f .env.dist .env
}

