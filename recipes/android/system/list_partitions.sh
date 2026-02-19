#!/bin/sh

## {
##   "namespace": "recipes/android/system",
##   "summary": "List partition",
##   "requires": [
##     "ls"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
list_partitions() {
    _echo_info 'adb shell ls -l /dev/block/bootdevice/by-name\n'
    adb shell ls -l /dev/block/bootdevice/by-name
}

