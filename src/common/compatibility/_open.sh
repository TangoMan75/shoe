#!/bin/sh

# Open with default handler
_open() {
    if [ "$(uname)" = 'Darwin' ]; then
        echo 'open'

        return 0
    fi

    echo 'xdg-open'
}

