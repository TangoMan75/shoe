#!/bin/sh

## {
##   "namespace": "recipes/android/unbrick",
##   "summary": "Flash all partitions from an extracted update.zip package",
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
flash_all() {
    _echo_info "ANDROID_PRODUCT_OUT='./' fastboot -w flashall\n"
    ANDROID_PRODUCT_OUT='./' fastboot -w flashall
}

