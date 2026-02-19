#!/bin/sh

## Start adb server
start() {
    _require adb
    _require fastboot

    _echo_info 'adb start-server\n'
    adb start-server

    infos
}

