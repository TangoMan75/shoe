#!/bin/sh

## Flash all partitions from an extracted update.zip package
##
## @namespace recipes/android/unbrick
## @requires fastboot
## @depends src/shell/colors/_echo_info.sh
flash_all() {
    _echo_info "ANDROID_PRODUCT_OUT='./' fastboot -w flashall\n"
    ANDROID_PRODUCT_OUT='./' fastboot -w flashall
}

