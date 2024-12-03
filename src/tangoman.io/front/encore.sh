#!/bin/sh

## Run webpack encore
encore() {
    if [ ! -x "$(command -v yarn)" ]; then
        echo_error "\"$(basename "${0}")\" requires yarn, try 'sudo apt-get install -y yarn'\n"
        return 1
    fi

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

