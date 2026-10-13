#!/bin/sh

## {
##   "namespace": "src/shell/android",
##   "summary": "Connect to device with adb via wifi (not recommended when flashing images)",
##   "requires": [
##     "adb"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_check_installed"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "IP",
##       "type": "str",
##       "description": "Device IP address.",
##       "required": true,
##       "constraint": "/^([0-9]{1,3}\\.){3}[0-9]{1,3}$/"
##     },
##     {
##       "position": 2,
##       "name": "PORT",
##       "type": "int",
##       "default": 5555,
##       "description": "Destination port.",
##       "constraint": "/^[0-9]{1,5}$/"
##     }
##   ]
## }
_adb_connect() {
    # Synopsis: _adb_connect <IP> [PORT]
    #   IP:   Device IP address.
    #   PORT: (optional) Destination port. (default=5555)

    _check_installed adb

    if [ -z "$1" ]; then _echo_error '_adb_connect: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_adb_connect: too many arguments ($#)\n"; return 1; fi

    set -- "$1" "${2:-5555}"

    _echo_info "adb connect \"$1:$2\"\n"
    adb connect "$1:$2"
}

