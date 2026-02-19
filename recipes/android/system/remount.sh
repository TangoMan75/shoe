#!/bin/sh

## Remount Android partitions
remount() {
    _echo_info 'adb remount\n'
    adb remount

    _echo_info 'adb shell mount -o rw,remount /system\n'
    adb shell mount -o rw,remount /system
}

