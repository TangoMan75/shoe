#!/bin/sh

## Check if symfony app is installed
_are_vendors_installed() {
    if [ -d ./vendor ]; then
        echo true
        return 0
    fi

    echo false
}

