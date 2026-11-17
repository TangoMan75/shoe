#!/bin/sh

## Flash system
##
## @namespace recipes/android/root
## @depends src/shell/android/_flash_img
## @assumes system
flash_system() {
    _flash_img "${system}" system
}

