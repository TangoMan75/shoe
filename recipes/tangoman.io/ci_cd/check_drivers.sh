#!/bin/sh

## Check drivers installation
##
## @namespace recipes/tangoman.io/ci_cd
## @depends src/shell/colors/_echo_info
check_drivers() {
    _echo_info './vendor/bin/bdi detect drivers\n'
    ./vendor/bin/bdi detect drivers
}

