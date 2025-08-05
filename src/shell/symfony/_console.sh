#!/bin/sh

# Get correct Symfony console binary path
#
# {
#   "namespace": "symfony",
#   "depends": [
#     "echo_danger"
#   ]
# }
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

    echo_danger "error: \"$(basename "${0}")\" symfony console not found, try: 'composer install'\n"
    exit 1
}

