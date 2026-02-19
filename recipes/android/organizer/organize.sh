#!/bin/sh

## Organize apks by category
organize() {
    # apps
    for file in \
        com.alanmobile.apk \
        com.amaze.filemanager.apk \
        com.artifex.mupdf.viewer.app.apk \
        com.boursorama.android.clients.apk \
        com.darkempire78.opencalculator.apk \
        com.dropbox.android.apk \
        com.estrongs.android.pop.apk \
        com.facebook.katana.apk \
        com.facebook.orca.apk \
        com.fullsix.android.labanquepostale.accountaccess.apk \
        com.garmin.android.apps.connectmobile.apk \
        com.github.tmo1.sms_ie.apk \
        com.instagram.android.apk \
        com.linkedin.android.apk \
        com.MarcosDiez.shareviahttp.apk \
        com.microsoft.copilot.apk \
        com.mp1.livolite.apk \
        com.mp1.livorec.apk \
        com.secuso.privacyFriendlyCodeScanner.apk \
        com.simplemobiletools.calculator.apk \
        com.simplemobiletools.contacts.pro.apk \
        com.simplemobiletools.filemanager.pro.apk \
        com.simplemobiletools.gallery.pro.apk \
        com.simplemobiletools.keyboard.apk \
        com.simplemobiletools.smsmessenger.apk \
        com.Slack.apk \
        com.smeiti.smstotext.apk \
        com.ttxapps.dropsync.apk \
        com.twitter.android.apk \
        com.whatsapp.apk \
        de.beowulf.wetter.apk \
        de.traderepublic.app.apk \
        fr.freebox.network.apk \
        fr.r0ro.android.FreeTelec.apk \
        hr.lunc.client.apk \
        io.github.muntashirakon.AppManager.apk \
        jbl.stc.com.apk \
        md.obsidian.apk \
        me.hackerchick.catima.apk \
        net.gitsaibot.af.apk \
        net.gsantner.markor.apk \
        org.aospstudio.files.apk \
        org.kde.bettercounter.apk \
        org.mozilla.firefox.apk \
        org.piwigo.android.apk \
        org.schabi.newpipe.apk \
        org.secuso.privacyfriendlyweather.apk \
        org.toilelibre.libe.athg2sms.apk \
        org.videolan.vlc.apk \
        org.woheller69.level.apk \
        spam.blocker.apk \
        splid.teamturtle.com.splid.apk \
        uk.co.openweather.apk \
        xyz.blueskyweb.app.apk \
    ; do
        _move "${source}/${file}" "${destination}/apps" || true
    done

    # gapps
    for file in \
        com.android.chrome.apk \
        com.android.vending.apk \
        com.google.android.apps.adm.apk \
        com.google.android.apps.authenticator2.apk \
        com.google.android.apps.bard.apk \
        com.google.android.apps.docs.apk \
        com.google.android.apps.docs.editors.docs.apk \
        com.google.android.apps.labs.language.tailwind.apk \
        com.google.android.apps.maps.apk \
        com.google.android.apps.messaging \
        com.google.android.apps.messaging_messages.android.apk \
        com.google.android.apps.nbu.files.apk \
        com.google.android.apps.photos.apk \
        com.google.android.apps.tachyon.apk \
        com.google.android.apps.tasks.apk \
        com.google.android.apps.youtube.music.apk \
        com.google.android.calendar.apk \
        com.google.android.contacts \
        com.google.android.dialer \
        com.google.android.documentsui.apk \
        com.google.android.gm.apk \
        com.google.android.gms.apk \
        com.google.android.googlequicksearchbox.apk \
        com.google.android.inputmethod.latin.apk \
        com.google.android.videos.apk \
        com.google.android.youtube.apk \
        com.google.ar.lens.apk \
    ; do
        _move "${source}/${file}" "${destination}/gapps" || true
    done

    # security
    for file in \
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
        _move "${source}/${file}" "${destination}/security" || true
    done

    # games
    for file in \
        air.mathmole.apk \
        appinventor.ai_ansonsavage.DiceRole_Magic8Ball_Extension_Two_Die.apk \
        com.androidemu.gbc.apk \
        com.androidemu.nes.apk \
        com.aspieapps.free.emulator.apk \
        com.chessclock.android.apk \
        com.chrislyle.pokerodds.apk \
        com.dozingcatsoftware.bouncy.apk \
        com.duolingo.apk \
        com.github.ashutoshgngwr.noice.apk \
        com.github.axet.binauralbeats.apk \
        com.glu.android.bonsai.apk \
        com.goodgorgon.gamegens.apk \
        com.infael.studio.seven_wonders_duel_scorekeeper.apk \
        com.johnemulators.johnsneslite.apk \
        com.kyhu.headsup.apk \
        com.leslie.cjpokeroddscalculator.apk \
        com.magicwach.rdefense.apk \
        com.nordbrew.sutom.apk \
        com.perunlabs.app.poker.apk \
        com.plusevpoker.apk \
        com.pnl.precisepokerodds.apk \
        com.seleuco.mame4droid.apk \
        com.swordfish.lemuroid.apk \
        com.tizmoplay.androgens.apk \
        com.uberspot.a2048.apk \
        com.yanstarstudio.joss.undercover.apk \
        com.zoomkoding.ephod.apk \
        com.zynga.livepoker.apk \
        coolcherrytrees.games.reactor4.apk \
        de.meonwax.soundboard.apk \
        de.vital.android.stack.apk \
        games.Ikigai.Flashcards.apk \
        gps.devineuf.apk \
        org.chromium.webapk.a7192d8aacd3c03e8.apk \
        org.covolunablu.marswallpaper.apk \
        org.dolphinemu.dolphinemu.apk \
        org.ppsspp.ppsspp.apk \
        org.secuso.privacyfriendlydame.apk \
        org.secuso.privacyfriendlydicer.apk \
    ; do
        _move "${source}/${file}" "${destination}/games" || true
    done
}

