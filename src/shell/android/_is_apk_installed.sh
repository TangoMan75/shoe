#!/bin/sh

# Check if package is installed on connected device
#
# {
#   "namespace": "android",
#   "requires": [
#     "adb"
#   ],
#   "depends": [
#     "_is_device_connected_with_adb",
#     "echo_danger"
#   ],
#   "parameters": [
#     {
#       "position": 1,
#       "name": "PACKAGE_NAME",
#       "type": "str",
#       "description": "The apk package name. eg: \"org.fdroid.fdroid\"",
#       "nullable": false
#     }
#   ]
# }
_is_apk_installed() {
    # Synopsis: _is_apk_installed <PACKAGE_NAME>
    #   PACKAGE_NAME: The apk package name. eg: "org.fdroid.fdroid"

    if ! _is_device_connected_with_adb; then
        echo_danger 'error: device not found\n'

        return 1
    fi

    if [ -z "$1" ]; then echo_danger 'error: _is_apk_installed: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _is_apk_installed: too many arguments (${#})\n"; return 1; fi

    if [ -z "$(adb shell cmd package path "$1")" ]; then

        return 1
    fi

    return 0
}

