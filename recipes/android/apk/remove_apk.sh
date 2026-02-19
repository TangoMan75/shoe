#!/bin/sh

## {
##   "namespace": "recipes/android/apk",
##   "summary": "Remove given APK from connected device",
##   "depends": [
##     "src/shell/android/_remove_apk"
##   ]
## }
remove_apk() {
    _remove_apk "${apk_name}" "${force}"
}

