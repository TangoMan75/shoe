#!/bin/sh

## Run webpack encore
encore() {
    _check_installed yarn

    echo_info 'yarn install\n'
    yarn install

    if [ "${env}" = prod ]; then
        echo_info 'yarn run encore production\n'
        yarn run encore production
    else
        echo_info 'yarn run encore dev\n'
        yarn run encore dev
    fi
}

