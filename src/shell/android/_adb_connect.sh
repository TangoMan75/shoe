#!/bin/sh

# Connect to device with adb via wifi (not recommended when flashing images)
_adb_connect() {
    # Synopsis: _adb_connect <IP> [PORT]
    #   IP:   Device IP address.
    #   PORT: (optional) Destination port. (default=5555)

    _check_installed adb

    if [ -z "$1" ]; then echo_danger 'error: _adb_connect: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _adb_connect: too many arguments (${#})\n"; return 1; fi

    set -- "$1" "${2:-5555}"

    echo_info "adb connect \"$1:$2\"\n"
    adb connect "$1:$2"
}

