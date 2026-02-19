#!/bin/sh

## Restart adb server as root
adb_root() {
    _echo_info 'adb root\n'
    adb root
}

