#!/bin/sh

## Flash vbmeta (Disable boot verification-AVB fix bootloop)
##
## @namespace recipes/android/root
## @depends src/shell/android/_flash_img
## @assumes vbmeta
flash_vbmeta() {
    _flash_img "${vbmeta}" vbmeta
}

