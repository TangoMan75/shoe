#!/bin/sh

## Watch with webpack encore
encore_watch() {
    if [ ! -x "$(command -v yarn)" ]; then
        echo_error "\"$(basename "${0}")\" requires yarn, try 'sudo apt-get install -y yarn'\n"
        return 1
    fi

    echo_info 'yarn install\n'
    yarn install

    echo_info 'yarn run encore dev --watch\n'
    yarn run encore dev --watch
}

