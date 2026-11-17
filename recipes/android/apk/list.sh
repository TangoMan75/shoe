#!/bin/sh

## List installed packages
##
## @namespace recipes/android/apk
## @requires awk
## @depends src/shell/android/_list_installed_apks
list() {
    _list_installed_apks | awk -F "=" '{print $NF}'
}

