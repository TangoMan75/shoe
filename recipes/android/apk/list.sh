#!/bin/sh

## List installed packages
list() {
    _list_installed_apks | awk -F "=" '{print $NF}'
}

