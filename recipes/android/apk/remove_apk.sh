#!/bin/sh

## Remove given APK from connected device
remove_apk() {
    _remove_apk "${apk_name}" "${force}"
}

