#!/bin/sh

## Open shell
##
## @namespace recipes/android/system
## @depends src/shell/colors/_echo_info
shell() {
    _echo_info 'adb shell\n'
    adb shell
}

