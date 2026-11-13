#!/bin/sh

## Execute script in phone
##
## @namespace recipes/android/system
## @requires basename realpath sh
## @depends src/shell/colors/_echo_info
execute() {
    file=$(basename "${file}")
    remote=$(adb shell realpath "${remote}")

    _echo_info "adb shell sh \"${remote}/${file}\"\n"
    adb shell sh "${remote}/${file}"
}

