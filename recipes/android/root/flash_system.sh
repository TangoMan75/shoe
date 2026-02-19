#!/bin/sh

## {
##   "namespace": "recipes/android/root",
##   "summary": "Flash system",
##   "depends": [
##     "src/shell/android/_flash_img"
##   ]
## }
flash_system() {
    _flash_img "${system}" system
}

