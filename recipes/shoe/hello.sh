#!/bin/sh

## Greets a specified recipient a given number of times (the recipient's name is provided with the "--who" option)
hello() {
    loop=0
    while [ "${loop}" -lt "${count}" ]; do
        echo "Hello, ${who} !"
        loop=$((loop+1))
    done
}

