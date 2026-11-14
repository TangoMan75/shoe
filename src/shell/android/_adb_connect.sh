#!/bin/sh

## Connect to device with adb via wifi (not recommended when flashing images)
##
## @namespace src/shell/android
## @requires adb
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/system/_check_installed
## @param {str} <IP> /^([0-9]{1,3}\\.){3}[0-9]{1,3}$/ (required) Device IP address.
## @param {int} <PORT> /^[0-9]{1,5}$/ (default:5555) Destination port.
_adb_connect() {
    _check_installed adb

    if [ -z "$1" ]; then _echo_error '_adb_connect: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_adb_connect: too many arguments ($#)\n"; return 1; fi

    set -- "$1" "${2:-5555}"

    _echo_info "adb connect \"$1:$2\"\n"
    adb connect "$1:$2"
}

