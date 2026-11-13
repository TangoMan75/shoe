#!/bin/sh

## Import logs
##
## @namespace recipes/datadome/app
## @depends src/shell/colors/_echo_info src/shell/symfony/_console
import() {
    _echo_info "$(_console) app:import ./imports/access.log\n"
    $(_console) app:import ./imports/access.log
}

