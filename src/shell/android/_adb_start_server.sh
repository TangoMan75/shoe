#!/bin/sh

## Start local adb server
##
## @namespace src/shell/android
## @requires adb
## @depends src/shell/colors/_echo_info src/shell/system/_check_installed
_adb_start_server() {
    _check_installed adb

    _echo_info 'adb start-server\n'
    adb start-server
}

