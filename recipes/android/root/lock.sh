#!/bin/sh

## Lock bootloader and flashing
##
## @namespace recipes/android/root
## @depends src/shell/android/_fastboot_lock.sh
lock() {
    _fastboot_lock
}

