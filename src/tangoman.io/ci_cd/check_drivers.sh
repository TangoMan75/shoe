#!/bin/sh

## Check drivers installation
check_drivers() {
    echo_info './vendor/bin/bdi detect drivers\n'
    ./vendor/bin/bdi detect drivers
}

