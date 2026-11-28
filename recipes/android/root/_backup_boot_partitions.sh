#!/bin/sh

## Back up the boot partitions of the connected device
##
## @namespace recipes/android/root
## @requires adb mkdir sleep tr
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @param {folder} <DESTINATION> (required) Directory where images are saved.
_backup_boot_partitions() {
    if [ -z "$1" ]; then
        _echo_error '_backup_boot_partitions: mandatory parameter is missing\n'

        return 1
    fi

    if [ $# -gt 1 ]; then
        _echo_error "_backup_boot_partitions: too many arguments ($#)\n"

        return 1
    fi

    if [ ! -d "$1" ]; then
        _echo_info "mkdir -p \"$1\"\n"
        mkdir -p "$1" || return 1
    fi

    partition_dir="$(adb shell \
        'if [ -d /dev/block/by-name ]; then
            printf /dev/block/by-name
        else
            printf /dev/block/bootdevice/by-name
        fi' | tr -d '\r')"

    if [ -z "${partition_dir}" ]; then
        _echo_error 'could not locate the block device directory\n'

        return 1
    fi

    for slot in a b; do
        _echo_info "adb shell dd if=${partition_dir}/boot_${slot} of=/tmp/boot_${slot}.img\n"
        adb shell "dd if=${partition_dir}/boot_${slot} of=/tmp/boot_${slot}.img" || return 1

        _echo_info "adb pull /tmp/boot_${slot}.img \"$1/boot_${slot}.img\"\n"
        adb pull "/tmp/boot_${slot}.img" "$1/boot_${slot}.img" || return 1
        adb shell "rm -f /tmp/boot_${slot}.img"
        sleep 4
    done

    return 0
}

