#!/bin/sh

## Prints flag status
flag_test() {
    if [ "${flag}" = true ]; then
        echo "Flag is on"

        return 0
    fi

    echo "Flag is off"
}
