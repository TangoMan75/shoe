#!/bin/sh

# Get sed flavour
_sed_flavor() {
    if [ "$(uname)" = 'Darwin' ] && [ -n "$(command -v sed)" ] && [ -z "$(sed --version 2>/dev/null)" ]; then
        echo 'Darwin'
        return 0
    fi

    echo 'Linux'
}

