#!/bin/sh

## {
##   "namespace": "recipes/android/root",
##   "summary": "Flash TWRP custom recovery image",
##   "depends": [
##     "src/shell/android/_flash_img"
##   ]
## }
flash_recovery() {
    _flash_img "${recovery}" recovery
}

