#!/bin/sh

## Flash all partitions from an extracted update.zip package
flash_all() {
    _echo_info "ANDROID_PRODUCT_OUT='./' fastboot -w flashall\n"
    ANDROID_PRODUCT_OUT='./' fastboot -w flashall
}

