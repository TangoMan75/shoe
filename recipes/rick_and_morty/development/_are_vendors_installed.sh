#!/bin/sh

## Check if symfony app is installed
##
## @namespace recipes/rick_and_morty/development
_are_vendors_installed() {
    if [ -d ./vendor ]; then

        return 0
    fi

    return 1
}

