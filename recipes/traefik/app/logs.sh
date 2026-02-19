#!/bin/sh

## {
##   "namespace": "recipes/traefik/app",
##   "summary": "Show traefik error log",
##   "requires": [
##     "tail"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
logs() {
    _echo_info 'tail -n 50 -f ./logs/error.log\n'
    tail -n 50 -f ./logs/error.log
}

