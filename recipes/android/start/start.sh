#!/bin/sh

## {
##   "namespace": "recipes/android/start",
##   "summary": "Start adb server",
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_require"
##   ]
## }
start() {
    _require adb
    _require fastboot

    _echo_info 'adb start-server\n'
    adb start-server

    infos
}

