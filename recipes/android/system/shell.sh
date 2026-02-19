#!/bin/sh

## {
##   "namespace": "recipes/android/system",
##   "summary": "Open shell",
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
shell() {
    _echo_info 'adb shell\n'
    adb shell
}

