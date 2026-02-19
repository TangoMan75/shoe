#!/bin/sh

## Remove extra google stock apps
remove_extra_google() {
    for apk in \
        com.android.calendar \
        com.android.chrome \
        com.android.documentsui \
        com.google.android.apps.maps \
        com.google.android.apps.nbu.files \
        com.google.android.apps.tasks \
        com.google.android.gm \
        com.google.android.youtube \
        com.google.ar.lens \
    ; do
        _remove_apk "${apk}" true
    done
}

