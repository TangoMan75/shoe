#!/bin/sh

## Check security issues in project dependencies (symfony-cli)
security() {
    if [ ! -x "$(command -v symfony)" ]; then
        echo_error "\"$(basename "${0}")\" requires symfony-cli"
        return 1
    fi

    echo_info 'symfony security:check\n'
    symfony security:check
}

