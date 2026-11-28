#!/bin/sh

## Open shell
##
## @namespace recipes/android/system
## @requires adb
## @depends src/shell/colors/_echo_info.sh
shell() {
    _echo_info 'adb shell\n'
    adb shell
}

