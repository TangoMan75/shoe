#!/bin/sh

## Wipe user data
##
## @namespace recipes/android/wipe
## @depends src/shell/android/_fastboot_wipe
wipe() {
    _fastboot_wipe
}

