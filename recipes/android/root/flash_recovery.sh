#!/bin/sh

## Flash TWRP custom recovery image
##
## @namespace recipes/android/root
## @depends src/shell/android/_flash_img
## @assumes recovery
flash_recovery() {
    _flash_img "${recovery}" recovery
}

