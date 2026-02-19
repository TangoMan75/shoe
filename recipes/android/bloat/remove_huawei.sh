#!/bin/sh

## Remove Huawei stock apps
remove_huawei() {
    # com.baidu.input_huawei              - Huawei chinese stock input keyboard
    # com.hicloud.android.clone           - Phone clone
    # com.huawei.android.airsharing       - Wireless Projection
    # com.huawei.android.chr              - HwChrService
    # com.huawei.android.FloatTasks       - Floating dock function
    # com.huawei.android.hsf              - Huawei Services Framework
    # com.huawei.android.hwpay            - Huawei Pay
    # com.huawei.android.instantshare     - Huawei Share
    # com.huawei.android.karaoke          - Karaoke mode feature
    # com.huawei.android.mirrorshare      - MirrorShare feature
    # com.huawei.android.remotecontroller - Juawei Smart Controller app
    # com.huawei.android.tips             - Huawei Tips
    # com.huawei.android.totemweather     - Huawei Weather app
    # com.huawei.android.wfdirect         - Wi-Fi Direct feature
    # com.huawei.appmarket                - Huawei Market app
    # com.huawei.ar.measure               - AR Measure
    # com.huawei.arengine.service         - Augmented reality service
    # com.huawei.bluetooth                - Import contact via Bluetooth function
    # com.huawei.browser                  - Huawei Browser app. More than safe to remove if you have another browser installed
    # com.huawei.compass                  - Huawei Compass app
    # com.huawei.contactscamcard          - CamCard is a business card reader app
    # com.huawei.desktop.explorer         - Service that is been used when you wanna use your phone as an operative system on a PC
    # com.huawei.fido.uafclient           - Fast ID Online function
    # com.huawei.filemanager              - Files
    # com.huawei.gameassistant            - Huawei Game Suite (HiGame)
    # com.huawei.geofence                 - GeofenceService
    # com.huawei.hdiw                     - Huawei ID app
    # com.huawei.hidisk                   - Huawei File Manager app
    # com.huawei.hifolder                 - Huawei Online Cloud folder service
    # com.huawei.himovie.overseas         - Huawei videos App
    # com.huawei.hitouch                  - Floating dock by Huawei
    # com.huawei.hwasm                    - FIDO UAF Autenthicator-Specific Module
    # com.huawei.hwdetectrepair           - Huawei Smart diagnosis app
    # com.huawei.hwdiagnosis              - HwDiagnosis
    # com.huawei.hwid                     - HMS Core
    # com.huawei.HwMultiScreenShot        - Sliding screen feature
    # com.huawei.hwvoipservice            - MEETime
    # com.huawei.iaware                   - Never understood what thid does, but hey it's safe to remove
    # com.huawei.ihealth                  - MotionService package, it's required for actions like shaking the phone to shut off the alarm, ecc
    # com.huawei.intelligent              - Assistant - TODAY
    # com.huawei.livewallpaper.paradise   - Live wallpaper service
    # com.huawei.maps.app                 - Petal Maps
    # com.huawei.mirror                   - Huawei Mirror app
    # com.huawei.parentcontrol            - Parental controls functions
    # com.huawei.pcassistant              - HiSuite service. If you use it, keep it
    # com.huawei.phoneservice             - HiCare app
    # com.huawei.scanner                  - AI Lens
    # com.huawei.screenrecorder           - Huawei Screen recorder feature
    # com.huawei.search                   - HiSearch
    # com.huawei.stylus.floatmenu         - Floating menu with M-Pen feature
    # com.huawei.systemmanager            - Optimizer
    # com.huawei.vassistant               - HiVoice app
    # com.huawei.videoeditor              - Video editor function
    # com.huawei.wallet                   - Huawei Wallet
    # com.huawei.watch.sync               - Huawei Watch sync function
    # com.iflytek.speechsuite             - Default voice input method
    # com.nuance.swype.emui               - Huawei Swype functions

    for apk in \
        com.baidu.input_huawei \
        com.example.android.notepad \
        com.hicloud.android.clone \
        com.huawei.android.airsharing \
        com.huawei.android.chr \
        com.huawei.android.FloatTasks \
        com.huawei.android.hsf \
        com.huawei.android.hwpay \
        com.huawei.android.hwupgradeguide\
        com.huawei.android.instantshare \
        com.huawei.android.karaoke \
        com.huawei.android.mirrorshare \
        com.huawei.android.remotecontroller \
        com.huawei.android.thememanager \
        com.huawei.android.tips \
        com.huawei.android.totemweather \
        com.huawei.android.wfdirect \
        com.huawei.appmarket \
        com.huawei.ar.measure \
        com.huawei.arengine.service \
        com.huawei.arengine.service\
        com.huawei.behaviorauth \
        com.huawei.bluetooth \
        com.huawei.browser \
        com.huawei.browser\
        com.huawei.compass \
        com.huawei.contactscamcard \
        com.huawei.desktop.explorer \
        com.huawei.entitlement\
        com.huawei.fastapp\
        com.huawei.fido.uafclient \
        com.huawei.filemanager \
        com.huawei.game.kitserver \
        com.huawei.gameassistant \
        com.huawei.gamebox\
        com.huawei.geofence \
        com.huawei.hdiw \
        com.huawei.health\
        com.huawei.hiai\
        com.huawei.hicloud \
        com.huawei.hidisk \
        com.huawei.hifolder \
        com.huawei.himovie.overseas \
        com.huawei.hitouch \
        com.huawei.hwasm \
        com.huawei.hwdetectrepair \
        com.huawei.hwdiagnosis \
        com.huawei.hwid \
        com.huawei.HwMultiScreenShot \
        com.huawei.hwread.dz\
        com.huawei.hwsearch\
        com.huawei.hwvoipservice \
        com.huawei.iaware \
        com.huawei.ihealth \
        com.huawei.intelligent \
        com.huawei.livewallpaper.paradise \
        com.huawei.maps.app \
        com.huawei.meetime \
        com.huawei.mirror \
        com.huawei.mycenter\
        com.huawei.parentcontrol \
        com.huawei.pcassistant \
        com.huawei.phoneservice \
        com.huawei.printservice \
        com.huawei.remotepassword \
        com.huawei.scanner \
        com.huawei.screenrecorder \
        com.huawei.search \
        com.huawei.stylus.floatmenu \
        com.huawei.systemmanager \
        com.huawei.tips \
        com.huawei.tipsove \
        com.huawei.vassistant \
        com.huawei.videoeditor \
        com.huawei.wallet \
        com.huawei.watch.sync \
        com.huawei.welinknow \
        com.iflytek.speechsuite \
        com.nuance.swype.emui \
    ; do
        _remove_apk "${apk}" true
    done
}

