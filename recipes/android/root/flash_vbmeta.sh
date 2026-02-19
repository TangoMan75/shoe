#!/bin/sh

## {
##   "namespace": "recipes/android/root",
##   "summary": "Flash vbmeta (Disable boot verification-AVB fix bootloop)",
##   "depends": [
##     "src/shell/android/_flash_img"
##   ]
## }
flash_vbmeta() {
    _flash_img "${vbmeta}" vbmeta
}

