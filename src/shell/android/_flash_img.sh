#!/bin/sh

## Flash img file to connected device provided partition
##
## @namespace src/shell/android
## @requires fastboot realpath true
## @depends src/shell/android/_is_device_connected_with_fastboot src/shell/colors/_echo_error src/shell/colors/_echo_info
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <PARTITION> (required) The name of the target partition.
## @param {bool} <FORCE> (default:false) Force install.
_flash_img() {
    if ! _is_device_connected_with_fastboot; then
        _echo_error 'please reboot to bootloader\n'

        return 1
    fi

    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_flash_img: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_flash_img: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "$2" "${3:-false}"
    if [ ! -f "$1" ]; then _echo_error "_flash_img: \"$1\" file not found\n"; return 1; fi

    if [ "$3" = true ]; then
        # fastboot flash <partition> [ <filename> ]
        # -S0 disable sparse
        _echo_info "fastboot --verbose --disable-verity --disable-verification flash \"$2\" \"$1\"\n"
        fastboot --verbose --disable-verity --disable-verification flash "$2" "$1"

        return 0
    fi

    _echo_info "fastboot --verbose flash \"$2\" \"$1\"\n"
    fastboot --verbose flash "$2" "$1"
}

