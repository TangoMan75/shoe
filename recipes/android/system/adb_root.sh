#!/bin/sh

## Restart adb server as root
##
## @namespace recipes/android/system
## @depends src/shell/colors/_echo_info
adb_root() {
    _echo_info 'adb root\n'
    adb root
}

