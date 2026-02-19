#!/bin/sh

## Import logs
##
## {
##   "namespace": "app",
##   "depends": [
##     "_console",
##     "_echo_info"
##   ]
## }
import() {
    _echo_info "$(_console) app:import ./imports/access.log\n"
    $(_console) app:import ./imports/access.log
}

