#!/bin/sh

# Start local adb server
_adb_start_server() {
    # Synopsis: _adb_start_server

    _check_installed adb

    echo_info 'adb start-server\n'
    adb start-server
}

