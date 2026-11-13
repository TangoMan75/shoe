#!/bin/sh

## Flash all partitions from an extracted update.zip package
##
## @namespace recipes/android/unbrick
## @depends src/shell/colors/_echo_info
flash_all() {
    _echo_info "ANDROID_PRODUCT_OUT='./' fastboot -w flashall\n"
    ANDROID_PRODUCT_OUT='./' fastboot -w flashall
}

