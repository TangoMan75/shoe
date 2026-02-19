#!/bin/sh

## {
##   "namespace": "recipes/android/apk",
##   "summary": "Dump installed packages list",
##   "depends": [
##     "src/shell/android/_list_installed_apks"
##   ]
## }
list_dump() {
    _list_installed_apks > package_list.txt
}

