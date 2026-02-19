#!/bin/sh

## List partition
list_partitions() {
    _echo_info 'adb shell ls -l /dev/block/bootdevice/by-name\n'
    adb shell ls -l /dev/block/bootdevice/by-name
}

