#!/bin/sh

## {
##   "namespace": "recipes/android/start",
##   "summary": "Connect adb via wifi (not recommended when flashing images)",
##   "depends": [
##     "src/shell/android/_adb_connect"
##   ]
## }
connect() {
    _adb_connect "${ip}" "${port}"
}

