#!/bin/sh

## Print user list
##
## @namespace recipes/android/system
## @requires adb users
## @depends src/shell/colors/_echo_info.sh
list_users() {
    _echo_info 'adb shell pm list users\n'
    adb shell pm list users
}

