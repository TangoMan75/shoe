#!/bin/sh

## {
##   "namespace": "recipes/android/system",
##   "summary": "Remount Android partitions",
##   "requires": [
##     "mount"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
remount() {
    _echo_info 'adb remount\n'
    adb remount

    _echo_info 'adb shell mount -o rw,remount /system\n'
    adb shell mount -o rw,remount /system
}

