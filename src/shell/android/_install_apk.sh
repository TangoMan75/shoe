#!/bin/sh

# Install APK on connected device
#
# {
#   "namespace": "android",
#   "requires": [
#     "adb"
#   ],
#   "depends": [
#     "_is_device_connected_with_adb",
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
#       "name": "FORCE",
#       "type": "bool",
#       "description": "Force install.",
#       "default": false
#     }
#   ]
# }
_install_apk() {
    # Synopsis: _install_apk <FILE_PATH> [FORCE]
    #   FILE_PATH: The path to the input file.
    #   FORCE:     (optional) Force install. Defaults to "false".

    if ! _is_device_connected_with_adb; then
        echo_danger 'error: device not found\n'

        return 1
    fi

    if [ -z "$1" ]; then echo_danger 'error: _install_apk: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _install_apk: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-false}"
    if [ ! -f "$1" ]; then echo_danger "error: _install_apk: \"$1\" file not found\n"; return 1; fi

    if [ "$2" = true ]; then
        # -r: replace existing application
        echo_info "adb install -r -g \"$1\" || true\n"
        adb install -r -g "$1" || true

        return 0
    fi

    # -g: grant all runtime permissions
    echo_info "adb install -g \"$1\" || true\n"
    adb install -g "$1" || true
}

