#!/bin/sh

## {
##   "namespace": "recipes/android/apk",
##   "summary": "List installed packages",
##   "requires": [
##     "awk"
##   ],
##   "depends": [
##     "src/shell/android/_list_installed_apks"
##   ]
## }
list() {
    _list_installed_apks | awk -F "=" '{print $NF}'
}

