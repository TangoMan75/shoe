#!/bin/sh

## Start adb server
##
## @namespace recipes/android/start
## @requires adb fastboot
## @depends recipes/android/start/infos.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/system/_require.sh
start() {
    _require adb
    _require fastboot

    _echo_info 'adb start-server\n'
    adb start-server

    infos
}

