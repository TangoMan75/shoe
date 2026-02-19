#!/bin/sh

## {
##   "namespace": "recipes/android/unbrick",
##   "summary": "Sideload given full OTA package to connected device",
##   "depends": [
##     "src/shell/android/_adb_sideload"
##   ]
## }
adb_sideload() {
    _adb_sideload "${file}"
}

