#!/bin/sh

## Watch with webpack encore
encore_watch() {
    _check_installed yarn

    _echo_info 'yarn install\n'
    yarn install

    _echo_info 'yarn run encore dev --watch\n'
    yarn run encore dev --watch
}

