#!/bin/sh

## Boot to given image temporarily
##
## @namespace recipes/android/reboot
## @depends src/shell/android/_reboot_with_img
## @assumes file
boot_with_img() {
    _reboot_with_img "${file}"
}

