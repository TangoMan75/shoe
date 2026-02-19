#!/bin/sh

## Remove Samsung stock apps
remove_samsung() {
    # com.cleanmaster.sdk                   - samsung smart manager
    # com.dsi.ant.plugins.antplus           - samsung radio
    # com.dsi.ant.sample.acquirechannels    - samsung radio
    # com.dsi.ant.server                    - samsung radio
    # com.dsi.ant.service.socket            - samsung radio
    # com.osp.app.signin                    - samsung account hero
    # com.samsung.android.app.memo          - notepad
    # com.samsung.android.sm                - samsung smart manager
    # com.samsung.android.sm.devicesecurity - samsung smart manager
    # com.samsung.android.sm.provider       - samsung smart manager
    # com.sec.android.app.fm                - radio
    # com.sec.android.app.myfiles           - file manager
    # com.sec.android.app.samsungapps       - galaxy store
    # com.sec.android.app.sbrowser          - samsung browser
    # com.sec.android.widgetapp.samsungapps - galaxy store widget
    # com.sec.spp.push                      - samsung push
    # com.samsung.android.app.contacts      - samsung contacts

    for apk in \
        android.autoinstalls.config.samsung.apk \
        com.aura.oobe.samsung.gl.apk \
        com.cleanmaster.sdk \
        com.dsi.ant.plugins.antplus \
        com.dsi.ant.sample.acquirechannels \
        com.dsi.ant.server \
        com.dsi.ant.service.socket \
        com.osp.app.signin \
        com.samsung.android.allshare.service.fileshare \
        com.samsung.android.app.colorblind \
        com.samsung.android.app.FileShareClient \
        com.samsung.android.app.FileShareServer \
        com.samsung.android.app.memo \
        com.samsung.android.app.settings.bixby.apk \
        com.samsung.android.app.simplesharing \
        com.samsung.android.app.spage.apk \
        com.samsung.android.app.tips.apk \
        com.samsung.android.ardrawing.apk \
        com.samsung.android.aremoji.apk \
        com.samsung.android.arzone.apk \
        com.samsung.android.bixby.agent.apk \
        com.samsung.android.bixby.wakeup.apk \
        com.samsung.android.bixbyvision.framework.apk \
        com.samsung.android.calendar.apk \
        com.samsung.android.easysetup \
        com.samsung.android.email.provider \
        com.samsung.android.game.gamehome.apk \
        com.samsung.android.game.gametools.apk \
        com.samsung.android.game.gos.apk \
        com.samsung.android.sm \
        com.samsung.android.sm.devicesecurity \
        com.samsung.android.sm.provider \
        com.samsung.android.themecenter \
        com.samsung.android.themestore \
        com.samsung.android.video \
        com.samsung.android.visionintelligence.apk \
        com.samsung.android.weather \
        com.samsung.android.widget.pictureframe.apk \
        com.samsung.gamedriver.sm8250.apk \
        com.samsung.klmsagent \
        com.samsung.knox.appsupdateagent \
        com.samsung.knox.rcp.components \
        com.samsung.SMT \
        com.sec.android.app.billing \
        com.sec.android.app.fm \
        com.sec.android.app.myfiles \
        com.sec.android.app.samsungapps \
        com.sec.android.app.sbrowser \
        com.sec.android.app.SecSetupWizard \
        com.sec.android.app.voicenote \
        com.sec.android.widgetapp.samsungapps \
        com.sec.knox.foldercontainer \
        com.sec.knox.switcher \
        com.sec.spp.push \
    ; do
        _remove_apk "${apk}" true
    done
}
