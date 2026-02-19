#!/bin/sh

## Remove LineageOS stock apps
remove_lineage() {
    # com.verizon.omadm         - verison
    # org.lineageos.audiofx     - audio effects
    # org.lineageos.eleven      - music player
    # org.lineageos.etar        - calendar
    # org.lineageos.jelly       - browser
    # org.lineageos.setupwizard - initializer

    for apk in \
        com.verizon.omadm \
        org.lineageos.audiofx \
        org.lineageos.eleven \
        org.lineageos.jelly \
        org.lineageos.overlay.accent.blue \
        org.lineageos.overlay.accent.brown \
        org.lineageos.overlay.accent.cyan \
        org.lineageos.overlay.accent.green \
        org.lineageos.overlay.accent.orange \
        org.lineageos.overlay.accent.pink \
        org.lineageos.overlay.accent.purple \
        org.lineageos.overlay.accent.red \
        org.lineageos.overlay.accent.yellow \
        org.lineageos.recorder \
        org.lineageos.setupwizard \
    ; do
        _remove_apk "${apk}" true
    done
}

