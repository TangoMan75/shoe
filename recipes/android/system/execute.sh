#!/bin/sh

## Execute script in phone
##
## @namespace recipes/android/system
## @requires adb basename realpath sh
## @depends src/shell/colors/_echo_info.sh
## @param {file} <input> (required) Path to the input file.
execute() {
    file=$(adb shell realpath "${file}")

    _echo_info "adb shell sh \"${file}\"\n"
    adb shell sh "${file}"
}

