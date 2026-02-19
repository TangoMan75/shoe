#!/bin/sh

## {
##   "namespace": "recipes/datadome/app",
##   "summary": "Import logs",
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/symfony/_console"
##   ]
## }
import() {
    _echo_info "$(_console) app:import ./imports/access.log\n"
    $(_console) app:import ./imports/access.log
}

