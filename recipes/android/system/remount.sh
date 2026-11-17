#!/bin/sh

## Remount Android partitions
##
## @namespace recipes/android/system
## @requires mount
## @depends src/shell/colors/_echo_info
remount() {
    _echo_info 'adb remount\n'
    adb remount

    _echo_info 'adb shell mount -o rw,remount /system\n'
    adb shell mount -o rw,remount /system
}

