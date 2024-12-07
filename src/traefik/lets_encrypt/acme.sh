#!/bin/sh

## Create empty Let's Encrypt acme.json file
acme() {
    echo_info 'touch ./config/acme.json\n'
    touch ./config/acme.json

    echo_info 'chmod 600 ./config/acme.json\n'
    chmod 600 ./config/acme.json
}

