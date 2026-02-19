#!/bin/sh

## Execute script in phone
execute() {
    file=$(basename "${file}")
    remote=$(adb shell realpath "${remote}")

    _echo_info "adb shell sh \"${remote}/${file}\"\n"
    adb shell sh "${remote}/${file}"
}

