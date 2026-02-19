#!/bin/sh

## {
##   "namespace": "recipes/android/system",
##   "summary": "Print user list",
##   "requires": [
##     "users"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
list_users() {
    _echo_info 'adb shell pm list users\n'
    adb shell pm list users
}

