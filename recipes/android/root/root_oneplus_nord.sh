#!/bin/sh

## Root a OnePlus Nord with Magisk
##
## The bootloader must be unlocked first with "unlock_oneplus_nord".
## This boots PitchBlack Recovery (PBRP), backs up both boot slots,
## flashes Magisk and reboots.
## No user data is erased by this command.
##
## @namespace recipes/android/root
## @requires adb fastboot reboot tr true
## @depends recipes/android/root/_backup_boot_partitions.sh
## @depends recipes/android/root/_install_magisk.sh
## @depends recipes/android/root/_is_rooted.sh
## @depends recipes/android/root/_is_unlocked.sh
## @depends recipes/android/root/_wait_for_android.sh
## @depends recipes/android/root/_wait_for_fastboot.sh
## @depends recipes/android/root/_wait_for_twrp.sh
## @depends recipes/android/root/download_oneplus_nord.sh
## @depends src/shell/android/_is_device_connected_with_adb.sh
## @depends src/shell/android/_is_device_connected_with_fastboot.sh
## @depends src/shell/colors/_alert_danger.sh
## @depends src/shell/colors/_alert_success.sh
## @depends src/shell/colors/_alert_warning.sh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/colors/_echo_muted.sh
## @depends src/shell/colors/_echo_success.sh
## @depends src/shell/colors/_echo_warning.sh
## @depends src/shell/prompts/_yes_no.sh
## @depends src/shell/system/_require.sh
## @assumes backup_dir magisk_apk recovery
root_oneplus_nord() {
    _echo_muted 'Rooting sequence: boot PBRP, back up boot, flash Magisk.\n\n'

    _echo_muted 'Checking that adb and fastboot are installed...\n'
    _echo_muted 'adb talks to Android; fastboot talks to the bootloader.\n'

    _require adb
    _require fastboot

    _echo_muted 'Looking for a device connected with adb or fastboot...\n'

    if ! _is_device_connected_with_adb \
        && ! _is_device_connected_with_fastboot
    then
        _echo_error 'root_oneplus_nord: device not connected\n'

        return 1
    fi

    if _is_device_connected_with_adb; then
        _echo_muted 'Reading the device model and build number...\n'
        _echo_muted 'They verify the device is the expected OnePlus Nord.\n'

        model="$(adb shell getprop ro.product.model 2>/dev/null | tr -d '\r')"
        build="$(adb shell getprop ro.build.display.id 2>/dev/null | tr -d '\r')"

        _echo_info "model: ${model}\n"
        _echo_info "build: ${build}\n"

        if [ "${model}" != 'AC2003' ]; then
            _alert_warning "Expected model AC2003, found \"${model}\"."

            if ! _yes_no 'Continue anyway?'; then
                return 1
            fi
        fi
    fi

    _echo_muted 'Checking whether the bootloader is unlocked...\n'
    _echo_muted 'A locked bootloader refuses custom recovery and boot writes.\n'

    if ! _is_unlocked; then
        _alert_warning 'The bootloader is locked.'
        _echo_info 'Unlock it first with:\n'
        _echo_info 'android.sh unlock_oneplus_nord\n'

        return 1
    fi

    _echo_muted 'Checking the Magisk APK and PBRP image...\n'
    _echo_muted 'Missing files are downloaded and verified with SHA-256.\n'

    download_oneplus_nord || return 1

    _echo_muted 'Preparing to boot PBRP and patch the boot partition.\n'
    _echo_muted 'PBRP normally runs from RAM; recovery is left untouched.\n'
    _echo_muted 'Magisk patches the boot image to start its root daemon.\n'
    _echo_muted 'A boot backup lets you restore the stock image if needed.\n\n'

    _alert_danger 'PBRP will start and Magisk will be flashed to boot.'
    _echo_warning 'Both boot slots will be backed up before flashing.\n\n'

    if ! _yes_no 'Root the device now?'; then
        _echo_info 'Aborted.\n'

        return 1
    fi

    if _is_device_connected_with_adb; then
        _echo_muted 'Rebooting Android into the bootloader (fastboot mode)...\n'
        _echo_muted 'fastboot must run to boot PBRP and write the boot image.\n'
        _echo_info 'adb reboot bootloader\n'
        adb reboot bootloader || true
    fi

    _echo_muted 'Waiting up to 60 seconds for fastboot to appear...\n'
    _wait_for_fastboot 60 || return 1

    _echo_muted 'Booting PBRP temporarily without replacing recovery...\n'
    _echo_info "fastboot boot \"${recovery}\"\n"
    fastboot boot "${recovery}" || return 1

    _echo_muted 'Waiting up to 120 seconds for PBRP and its adb daemon...\n'

    if ! _wait_for_twrp 120; then
        _echo_warning 'PBRP did not start.\n'
        _echo_warning 'Check the PBRP image for this build.\n'

        return 1
    fi

    _echo_muted 'Backing up boot_a and boot_b before changing anything...\n'
    _echo_muted 'Keep these images: they restore the stock boot if needed.\n'
    _backup_boot_partitions "${backup_dir}" || return 1

    _echo_info 'Flashing Magisk into the active boot slot...\n'
    _echo_muted 'Magisk modifies the boot image and embeds its binaries.\n'
    _install_magisk "${magisk_apk}" || return 1

    _echo_muted 'Rebooting into Android to complete the first Magisk boot...\n'
    _echo_info 'adb reboot\n'
    adb reboot || true

    _echo_muted 'Waiting up to 180 seconds for Android to finish booting...\n'

    if ! _wait_for_android 180; then
        _echo_warning 'The device did not finish booting in time.\n'

        return 1
    fi

    _echo_muted 'Installing the Magisk app to manage superuser requests...\n'
    _echo_info "adb install -r \"${magisk_apk}\"\n"
    adb install -r "${magisk_apk}" || _echo_warning '\nCould not install the Magisk app automatically.\n'

    _echo_success 'Magisk has been flashed.\n'
    _echo_info "Boot backup: ${backup_dir}\n"
    _echo_muted 'The backup contains boot_a.img and boot_b.img.\n'
    _echo_muted 'Magisk asks for confirmation before granting root access.\n'
    _echo_muted 'Unlock the device and approve the request in the Magisk app.\n'
    _echo_muted 'Root access is required by system-level apps and tools.\n'
    _echo_muted 'Verify with: adb shell su -c id\n'

    if _yes_no 'Grant root access on the device, then confirm'; then
        if _is_rooted; then
            _alert_success 'Root access verified.'

            return 0
        fi

        _echo_warning 'Could not verify root access.\n'
    fi

    return 0
}

