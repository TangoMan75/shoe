#!/bin/sh

## {
##   "namespace": "recipes/android/root",
##   "summary": "Toggle active slot",
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
toggle_active_slot() {
    _echo_info 'fastboot set_active other\n'
    fastboot set_active other
}

