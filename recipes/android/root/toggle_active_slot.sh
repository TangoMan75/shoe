#!/bin/sh

## Toggle active slot
##
## @namespace recipes/android/root
## @requires fastboot
## @depends src/shell/colors/_echo_info.sh
toggle_active_slot() {
    _echo_info 'fastboot set_active other\n'
    fastboot set_active other
}

