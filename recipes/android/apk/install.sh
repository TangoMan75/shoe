#!/bin/sh

## {
##   "namespace": "recipes/android/apk",
##   "summary": "Install apks from source folder",
##   "requires": [
##     "adb",
##     "find",
##     "realpath",
##     "sort",
##     "true"
##   ],
##   "depends": [
##     "src/shell/android/_install_apk",
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info"
##   ]
## }
install() {
    source="$(realpath "${source}")"
    if [ ! -d "${source}" ]; then
        _echo_error "folder not found : \"${source}\"\n"
        return 1
    fi

    # disable apk verification (deprecated)
    # Exception occurred while executing 'put':
    # java.lang.SecurityException: Permission denial: writing to settings requires:android.permission.WRITE_SECURE_SETTINGS
    _echo_info 'adb shell settings put global verifier_verify_adb_installs 0 || true\n'
    adb shell settings put global verifier_verify_adb_installs 0 || true

    find "${source}" -type f -name '*.apk' | sort -t '\0' -n | while read -r apk
    do
        _install_apk "${apk}" true
    done
}

