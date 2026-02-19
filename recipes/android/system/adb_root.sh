#!/bin/sh

## {
##   "namespace": "recipes/android/system",
##   "summary": "Restart adb server as root",
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
adb_root() {
    _echo_info 'adb root\n'
    adb root
}

