#!/bin/sh

## Remove Security Tools
remove_security() {
    for apk in \
        aws.apps.wifiKeyRecovery.apk \
        cf.theonewiththebraid.guerrilla_mail.apk \
        ch.protonvpn.android.apk \
        com.aurora.store.apk \
        com.github.axet.callrecorder.apk \
        com.htetznaing.adbotg.apk \
        com.ivuu.apk \
        com.joeykrim.rootcheck.apk \
        com.offsec.nethunter.apk \
        com.offsec.nethunter.kex.apk \
        com.offsec.nethunter.store.apk \
        com.offsec.nhterm.apk \
        com.termux.apk \
        com.topjohnwu.magisk.apk \
        com.zimperium.zanti.apk \
        de.csicar.ning.apk \
        de.seemoo.at_tracking_detection.apk \
        de.srlabs.snoopsnitch.apk \
        net.wigle.wigleandroid.apk \
        net.yolosec.routerkeygen2.apk \
        org.adaway.apk \
        org.bitbatzen.wlanscanner.apk \
        org.csploit.android.apk \
        org.exobel.routerkeygen.apk \
        org.fdroid.fdroid.apk \
        org.mistergroup.shouldianswer.apk \
        org.pocketworkstation.pckeyboard.apk \
        org.torproject.android.apk \
        org.torproject.torbrowser.apk \
        org.underdev.penetratepro.apk \
        ru.seva.finder.apk \
        sk.xorsk.btinfo.apk \
        tech.ula.apk \
    ; do
        _remove_apk "${apk}" true
    done
}

