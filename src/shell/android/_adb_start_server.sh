#!/bin/sh

# Start local adb server
#
# {
#   "namespace": "android",
#   "requires": [
#     "adb"
#   ],
#   "depends": [
#     "_check_installed",
#     "echo_info"
#   ]
# }
_adb_start_server() {
    # Synopsis: _adb_start_server

    _check_installed adb

    echo_info 'adb start-server\n'
    adb start-server
}

