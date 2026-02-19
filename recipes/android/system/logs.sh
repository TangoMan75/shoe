#!/bin/sh

## {
##   "namespace": "recipes/android/system",
##   "summary": "Print error logs",
##   "requires": [
##     "grep",
##     "pidof"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
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

