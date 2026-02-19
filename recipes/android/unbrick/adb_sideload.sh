#!/bin/sh

## Sideload given full OTA package to connected device
adb_sideload() {
    _adb_sideload "${file}"
}

