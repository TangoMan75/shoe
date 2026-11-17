#!/bin/sh

## Unlock bootloader and flashing
##
## @namespace recipes/android/root
## @depends src/shell/android/_fastboot_unlock
unlock() {
    _fastboot_unlock
}

