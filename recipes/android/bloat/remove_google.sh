#!/bin/sh

## Remove google stock apps
remove_google() {
    # com.android.calendar                      - calendar
    # com.android.egg                           - easter egg
    # com.android.email                         - email client
    # com.android.printservice.recommendation   - printservice
    # com.android.printspooler                  - printspooler
    # com.android.tts                           - text to speech
    # com.android.wallpaperbackup               - wallpaperbackup
    # com.android.wallpapercropper              - wallpapercropper
    # com.google.android.apps.docs              - drive
    # com.google.android.apps.googleassistant   - google assistant
    # com.google.android.apps.magazines         - google news
    # com.google.android.apps.photos            - photos
    # com.google.android.apps.podcasts          - google podcasts
    # com.google.android.apps.subscriptions.red - google one
    # com.google.android.apps.tachyon           - duo / meet
    # com.google.android.feedback               - google feedback
    # com.google.android.googlequicksearchbox   - quicksearch
    # com.google.android.marvin.talkback        - Android Accessibility Suite
    # com.google.android.music                  - Google Play Music
    # com.google.android.onetimeinitializer     - initializer
    # com.google.android.projection.gearhead    - Android Auto
    # com.google.android.setupwizard            - initializer
    # com.google.android.talk                   - hangouts
    # com.google.android.tts                    - text to speech
    # com.google.android.videos                 - Google TV
    # com.sec.android.app.SecSetupWizard        - initializer

    for apk in \
        com.android.egg \
        com.android.email \
        com.android.gallery3d \
        com.android.mediacenter \
        com.android.musicfx \
        com.android.printservice.recommendation \
        com.android.printspooler \
        com.android.providers.partnerbookmarks \
        com.android.soundrecorder \
        com.android.tts \
        com.android.wallpaperbackup \
        com.android.wallpapercropper \
        com.google.android.apps.books \
        com.google.android.apps.cloudprint \
        com.google.android.apps.currents \
        com.google.android.apps.docs \
        com.google.android.apps.docs.editors.docs \
        com.google.android.apps.docs.editors.sheets \
        com.google.android.apps.docs.editors.slides \
        com.google.android.apps.fitness \
        com.google.android.apps.googleassistant \
        com.google.android.apps.inputmethod.hindi \
        com.google.android.apps.magazines \
        com.google.android.apps.pdfviewer \
        com.google.android.apps.photos \
        com.google.android.apps.plus \
        com.google.android.apps.podcasts \
        com.google.android.apps.restore \
        com.google.android.apps.subscriptions.red \
        com.google.android.apps.tachyon \
        com.google.android.apps.walletnfcrel \
        com.google.android.apps.wellbeing \
        com.google.android.apps.youtube.music \
        com.google.android.documentsui \
        com.google.android.feedback \
        com.google.android.googlequicksearchbox \
        com.google.android.inputmethod.japanese \
        com.google.android.inputmethod.korean \
        com.google.android.inputmethod.pinyin \
        com.google.android.keep \
        com.google.android.marvin.talkback \
        com.google.android.music \
        com.google.android.onetimeinitializer \
        com.google.android.overlay.modules.documentsui \
        com.google.android.play.games \
        com.google.android.printservice.recommendation \
        com.google.android.projection.gearhead \
        com.google.android.setupwizard \
        com.google.android.street \
        com.google.android.talk \
        com.google.android.tts \
        com.google.android.videos \
        com.google.ar.core \
        com.google.tango.measure \
        com.opengapps.wellbeingoverlay \
        com.sec.android.app.SecSetupWizard \
    ; do
        _remove_apk "${apk}" true
    done
}

