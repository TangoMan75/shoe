#!/bin/sh

# Get Symfony correct console binary path
_console() {
    if [ -f ./app/console ]; then
        echo './app/console'

        return 0
    fi

    if [ -f ./bin/console ]; then
        echo './bin/console'

        return 0
    fi

    echo_danger "error: \"$(basename "${0}")\" requires symfony, try: 'composer install'\n"
    return 1
}

