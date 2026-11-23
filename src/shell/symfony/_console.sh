#!/bin/sh

## Get correct Symfony console binary path
##
## Returns a failing status instead of exiting, so a caller that probes
## for a console from a command substitution is not terminated.
##
## @namespace src/shell/symfony
## @requires echo symfony
## @depends src/shell/colors/_echo_error.sh
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

    _echo_error "\"${0##*/}\" symfony console not found, try: 'composer install'\n"

    return 1
}

