#!/bin/sh

## Show traefik error log
##
## {
##   "namespace": "app",
##   "requires": [
##     "tail"
##   ],
##   "depends": [
##     "_echo_info"
##   ]
## }
logs() {
    _echo_info 'tail -n 50 -f ./logs/error.log\n'
    tail -n 50 -f ./logs/error.log
}

