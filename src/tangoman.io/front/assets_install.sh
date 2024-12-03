#!/bin/sh

## Install bundle assets
assets_install() {
    echo_info "./bin/console assets:install --env=\"${env}\"\n"
    ./bin/console assets:install --env="${env}"
}

