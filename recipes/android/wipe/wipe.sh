#!/bin/sh

## {
##   "namespace": "recipes/android/wipe",
##   "summary": "Wipe user data",
##   "depends": [
##     "src/shell/android/_fastboot_wipe"
##   ]
## }
wipe() {
    _fastboot_wipe
}

