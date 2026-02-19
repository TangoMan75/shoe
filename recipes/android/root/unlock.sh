#!/bin/sh

## {
##   "namespace": "recipes/android/root",
##   "summary": "Unlock bootloader and flashing",
##   "depends": [
##     "src/shell/android/_fastboot_unlock"
##   ]
## }
unlock() {
    _fastboot_unlock
}

