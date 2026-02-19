#!/bin/sh

## {
##   "namespace": "recipes/android/reboot",
##   "summary": "Boot to backup recovery image temporarily",
##   "depends": [
##     "src/shell/android/_reboot_with_img"
##   ]
## }
boot_with_backup_recovery() {
    _reboot_with_img './oneplus_nord/backup/recovery.img'
}

