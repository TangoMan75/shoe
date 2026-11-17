#!/bin/sh

## Install bundle assets
##
## @namespace recipes/tangoman.io/front
## @requires php
## @depends src/shell/colors/_echo_info
## @assumes env
assets_install() {
    _echo_info "php bin/console assets:install --env=\"${env}\"\n"
    php bin/console assets:install --env="${env}"
}

