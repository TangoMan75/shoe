#!/bin/sh

## {
##   "namespace": "recipes/android/reboot",
##   "summary": "Reboot to bootloader",
##   "depends": [
##     "src/shell/android/_reboot_bootloader"
##   ]
## }
reboot_bootloader() {
    _reboot_bootloader
}

