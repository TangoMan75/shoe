#!/bin/sh

## Connect adb via wifi (not recommended when flashing images)
connect() {
    _adb_connect "${ip}" "${port}"
}

