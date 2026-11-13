#!/bin/sh

## Dump installed packages list
##
## @namespace recipes/android/apk
## @depends src/shell/android/_list_installed_apks
list_dump() {
    _list_installed_apks > package_list.txt
}

