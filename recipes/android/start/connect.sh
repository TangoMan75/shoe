#!/bin/sh

## Connect adb via wifi (not recommended when flashing images)
##
## @namespace recipes/android/start
## @depends src/shell/android/_adb_connect.sh
## @assumes ip port
connect() {
    _adb_connect "${ip}" "${port}"
}

