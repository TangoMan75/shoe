#!/bin/sh

## Say hello to arbitrary recipient
hello() {
    loop=0
    while [ "${loop}" -lt "${count}" ]; do
        echo "Hello, ${who} !"
        loop=$((loop+1))
    done

    if [ "${flag}" = true ]; then
        echo "FOOBAR MODE ENABLED !"
    fi
}

