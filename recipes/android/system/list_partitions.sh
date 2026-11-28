#!/bin/sh

## List partition
##
## @namespace recipes/android/system
## @requires adb ls
## @depends src/shell/colors/_echo_info.sh
list_partitions() {
    _echo_info 'adb shell ls -l /dev/block/bootdevice/by-name\n'
    adb shell ls -l /dev/block/bootdevice/by-name
}

