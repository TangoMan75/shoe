#!/bin/sh

## Remove One Plus stock apps
remove_one_plus() {
    for apk in \
        com.oneplus.backuprestore \
        com.oneplus.brickmode \
        com.oneplus.calculator \
        com.oneplus.canvas \
        com.oneplus.canvasresources \
        com.oneplus.clock \
        com.oneplus.filemanager \
        com.oneplus.gallery \
        com.oneplus.gamespace \
        com.oneplus.membership \
        com.oneplus.note \
        com.oneplus.opscout \
        com.oneplus.opshelf \
        com.oneplus.opwlb \
        com.oneplus.setupwizard \
        com.oneplus.soundrecorder \
        com.oneplus.store \
        com.oplus.games \
        com.oplus.gesture \
        net.oneplus.forums \
        net.oneplus.weather \
    ; do
        _remove_apk "${apk}" true
    done
}

