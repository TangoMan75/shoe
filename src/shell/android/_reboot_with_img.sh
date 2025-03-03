#!/bin/sh

# Boot connected device with given image temporarily
#
# {
#   "namespace": "android",
#   "requires": [
#     "fastboot"
#   ],
#   "depends": [
#     "_is_device_connected_with_fastboot",
#     "echo_danger",
#     "echo_info"
#   ],
#   "parameters": [
#     {
#       "position": 1,
#       "name": "FILE_PATH",
#       "type": "file",
#       "description": "The path to the input file.",
#       "nullable": false
#     }
#   ]
# }
_reboot_with_img() {
    # Synopsis: _reboot_with_img <FILE_PATH>
    #   FILE_PATH: The path to the input file.

    if ! _is_device_connected_with_fastboot; then
        echo_danger 'error: please reboot to bootloader\n'

        return 1
    fi

    if [ -z "$1" ]; then echo_danger 'error: _reboot_with_img: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _reboot_with_img: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then echo_danger "error: _reboot_with_img: \"$1\" file not found\n"; return 1; fi

    echo_info "fastboot --verbose boot \"$1\"\n"
    fastboot --verbose boot "$1"
}

