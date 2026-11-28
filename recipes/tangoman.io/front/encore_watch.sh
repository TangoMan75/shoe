#!/bin/sh

## Watch with webpack encore
##
## @namespace recipes/tangoman.io/front
## @requires install yarn
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/system/_check_installed.sh
encore_watch() {
    _check_installed yarn

    _echo_info 'yarn install\n'
    yarn install

    _echo_info 'yarn run encore dev --watch\n'
    yarn run encore dev --watch
}

