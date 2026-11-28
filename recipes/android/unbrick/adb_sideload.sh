#!/bin/sh

## Sideload given full OTA package to connected device
##
## @namespace recipes/android/unbrick
## @depends src/shell/android/_adb_sideload.sh
## @assumes file
adb_sideload() {
    _adb_sideload "${file}"
}

