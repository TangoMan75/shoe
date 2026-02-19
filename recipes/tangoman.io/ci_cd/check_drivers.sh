#!/bin/sh

## Check drivers installation
##
## {
##   "namespace": "ci_cd",
##   "depends": [
##     "_echo_info"
##   ]
## }
check_drivers() {
    _echo_info './vendor/bin/bdi detect drivers\n'
    ./vendor/bin/bdi detect drivers
}

