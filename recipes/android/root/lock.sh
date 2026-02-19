#!/bin/sh

## {
##   "namespace": "recipes/android/root",
##   "summary": "Lock bootloader and flashing",
##   "depends": [
##     "src/shell/android/_fastboot_lock"
##   ]
## }
lock() {
    _fastboot_lock
}

