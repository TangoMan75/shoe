#!/bin/sh

## Prints flag status
test_flag() {
    if [ "${flag}" = true ]; then
        echo "Flag is on"

        return 0
    fi

    echo "Flag is off"
}

