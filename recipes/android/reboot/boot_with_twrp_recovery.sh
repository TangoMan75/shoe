#!/bin/sh

## Boot to TWRP custom recovery image temporarily
##
## @namespace recipes/android/reboot
## @depends src/shell/android/_reboot_with_img
## @assumes recovery
boot_with_twrp_recovery() {
    _reboot_with_img "${recovery}"
}

