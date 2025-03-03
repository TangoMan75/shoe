#!/bin/sh

# Flash img file to connected device provided partition
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
#     },
#     {
#       "position": 2,
#       "name": "PARTITION",
#       "type": "str",
#       "description": "The name of the target partition.",
#       "nullable": false
#     },
#     {
#       "position": 3,
#       "name": "FORCE",
#       "type": "bool",
#       "description": "Force install.",
#       "default": false
#     }
#   ]
# }
_flash_img() {
    # Synopsis: _flash_img <FILE_PATH> <PARTITION> [FORCE]
    #   FILE_PATH: The path to the image file.
    #   PARTITION: The name of the target partition.
    #   FORCE:     (optional) Force install. Defaults to "false".

    if ! _is_device_connected_with_fastboot; then
        echo_danger 'error: please reboot to bootloader\n'

        return 1
    fi

    if [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: _flash_img: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _flash_img: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "$2" "${3:-false}"
    if [ ! -f "$1" ]; then echo_danger "error: _flash_img: \"$1\" file not found\n"; return 1; fi

    if [ "$3" = true ]; then
        # fastboot flash <partition> [ <filename> ]
        # -S0 disable sparse
        echo_info "fastboot --verbose --disable-verity --disable-verification flash \"$2\" \"$1\"\n"
        fastboot --verbose --disable-verity --disable-verification flash "$2" "$1"

        return 0
    fi

    echo_info "fastboot --verbose flash \"$2\" \"$1\"\n"
    fastboot --verbose flash "$2" "$1"
}

