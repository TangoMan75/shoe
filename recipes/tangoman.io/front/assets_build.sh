#!/bin/sh

## Build Sass and compiled assets
##
## @namespace recipes/tangoman.io/front
## @requires php
## @depends src/shell/colors/_echo_info
## @assumes env
assets_build() {
    _echo_info "php bin/console sass:build --env=\"${env}\"\n"
    php bin/console sass:build --env="${env}"

    if [ "${env}" = prod ]; then
        _echo_info "php bin/console asset-map:compile --env=\"${env}\"\n"
        php bin/console asset-map:compile --env="${env}"
    fi
}

