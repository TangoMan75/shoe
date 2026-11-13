#!/bin/sh

## Remove given APK from connected device
##
## @namespace recipes/android/apk
## @depends src/shell/android/_remove_apk
## @assumes apk_name force
remove_apk() {
    _remove_apk "${apk_name}" "${force}"
}

