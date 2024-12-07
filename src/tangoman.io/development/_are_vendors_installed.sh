#!/bin/sh

# Check if symfony app is installed
_are_vendors_installed() {
    if [ -d ./vendor ]; then

        return 0
    fi

    return 1
}

