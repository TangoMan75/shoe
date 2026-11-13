#!/bin/sh

## Print user list
##
## @namespace recipes/android/system
## @requires users
## @depends src/shell/colors/_echo_info
list_users() {
    _echo_info 'adb shell pm list users\n'
    adb shell pm list users
}

