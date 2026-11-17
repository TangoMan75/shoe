#!/bin/sh

## Print error logs
##
## @namespace recipes/android/system
## @requires grep pidof
## @depends src/shell/colors/_echo_info
## @assumes apk_name
logs() {
    if [ -z "${apk_name}" ]; then
        _echo_info "adb logcat -s '*:E'\n"
        adb logcat -s '*:E'

        return
    fi

    _echo_info "adb shell pidof \"${apk_name}\"\n"
    PID="$(adb shell pidof "${apk_name}")"

    _echo_info "adb logcat -s '*:E' | grep \"${PID}\"\n"
    adb logcat -s '*:E' | grep "${PID}"
}

