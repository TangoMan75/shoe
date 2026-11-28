#!/bin/sh

## Restart adb server as root
##
## @namespace recipes/android/system
## @requires adb
## @depends src/shell/colors/_echo_info.sh
adb_root() {
    _echo_info 'adb root\n'
    adb root
}

