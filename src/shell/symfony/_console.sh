#!/bin/sh

## Get correct Symfony console binary path
##
## {
##   "namespace": "symfony",
##   "depends": [
##     "_echo_error"
##   ]
## }
_console() {
    if [ -x "$(command -v symfony)" ]; then
        echo 'symfony console'

        return 0
    fi

    if [ -f ./app/console ]; then
        echo './app/console'

        return 0
    fi

    if [ -f ./bin/console ]; then
        echo './bin/console'

        return 0
    fi

    _echo_error "\"$(basename "${0}")\" symfony console not found, try: 'composer install'\n"
    exit 1
}

