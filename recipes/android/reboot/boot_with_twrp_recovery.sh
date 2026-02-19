#!/bin/sh

## {
##   "namespace": "recipes/android/reboot",
##   "summary": "Boot to TWRP custom recovery image temporarily",
##   "depends": [
##     "src/shell/android/_reboot_with_img"
##   ]
## }
boot_with_twrp_recovery() {
    _reboot_with_img "${recovery}"
}

