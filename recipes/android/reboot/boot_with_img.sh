#!/bin/sh

## {
##   "namespace": "recipes/android/reboot",
##   "summary": "Boot to given image temporarily",
##   "depends": [
##     "src/shell/android/_reboot_with_img"
##   ]
## }
boot_with_img() {
    _reboot_with_img "${file}"
}

