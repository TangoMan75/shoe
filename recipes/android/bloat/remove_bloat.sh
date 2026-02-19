#!/bin/sh

## Remove Bloat apps
remove_bloat() {
    # com.microsoft.translator - Translator
    # com.touchtype.swiftkey   - Microsoft SwiftKey Keyboard

    for apk in \
        com.amazon.aa \
        com.amazon.aa.attribution \
        com.amazon.appmanager \
        com.amazon.mShop.android.shopping \
        com.booking \
        com.ebay.mobile \
        com.facebook.appmanager \
        com.facebook.katana \
        com.facebook.lite.apk \
        com.facebook.mlite.apk \
        com.facebook.orca \
        com.facebook.services \
        com.facebook.system \
        com.instagram.android \
        com.microsoft.office.excel \
        com.microsoft.office.onenote \
        com.microsoft.office.powerpoint \
        com.microsoft.office.word \
        com.microsoft.skydrive \
        com.microsoft.translator \
        com.netflix.mediaclient \
        com.netflix.partner.activation \
        com.skype.raider \
        com.snapchat.android \
        com.swiftkey.swiftkeyconfigurator \
        com.touchtype.swiftkey \
        com.twitter.android \
    ; do
        _remove_apk "${apk}" true
    done
}

