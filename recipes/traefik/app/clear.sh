#!/bin/sh

## Clear logs
##
## {
##   "namespace": "app",
##   "requires": [
##     "rm"
##   ],
##   "depends": [
##     "_echo_info"
##   ]
## }
clear() {
    _echo_info 'rm -f ./logs/*.log || true\n'
    rm -f ./logs/*.log || true
}

