#!/bin/sh

## Start adb server
##
## @namespace recipes/android/start
## @depends recipes/android/start/infos src/shell/colors/_echo_info src/shell/system/_require
start() {
    _require adb
    _require fastboot

    _echo_info 'adb start-server\n'
    adb start-server

    infos
}

