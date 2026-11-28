#!/bin/sh

## Dump partition
##
## @namespace recipes/android/system
## @requires adb cut dd grep ls
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
dump_partition() {
    _partition_name=boot_a
    _filename="${_partition_name}.img"
    _partition="$(adb shell ls -l /dev/block/bootdevice/by-name | grep "${_partition_name}" | cut -d'>' -f2)"
    # remove leading whitespace
    _partition="${_partition# }"

    if [ -z "${_partition}" ] && [ -z "/sdcard" ] && [ -z "${_filename}" ]; then
        _echo_error "could not dump \"${_partition}\" to \"/sdcard/${_filename}\""
        return 1
    fi

    _echo_info "adb shell dd if=\"${_partition}\" of=\"/sdcard/${_filename}\"\n"
    adb shell dd if="${_partition}" of="/sdcard/${_filename}"
}

