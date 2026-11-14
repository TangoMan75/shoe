#!/bin/bash

# This file is part of TangoMan Shoe package.
#
# This file is distributed under to the MIT license.
#
# Copyright (c) 2026 "Matthias Morin" <mat@tangoman.io>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# Source code is available here: https://github.com/TangoMan75/shoe

source "../../../src/shell/android/_fastboot_lock.sh"
source "../../../src/shell/android/_fastboot_unlock.sh"
source "../../../src/shell/android/_fastboot_wipe.sh"
source "../../../src/shell/android/_flash_img.sh"
source "../../../src/shell/android/_get_apk_label.sh"
source "../../../src/shell/android/_get_apk_package_name.sh"
source "../../../src/shell/android/_get_apk_version.sh"
source "../../../src/shell/android/_reboot_bootloader.sh"
source "../../../src/shell/android/_reboot_recovery.sh"
source "../../../src/shell/android/_reboot_system.sh"
source "../../../src/shell/android/_reboot_with_img.sh"
source "../../../src/shell/android/_toggle_active_slot.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_check_installed() { return 0; }
_echo_error() { printf '%b' "$1"; }
_echo_info() { :; }
_is_device_connected_with_adb() { [ -n "${__adb_connected__:-}" ]; }
_is_device_connected_with_fastboot() { [ -z "${__fastboot_missing__:-}" ]; }
aapt() {
    printf '%s\n' \
        "package: name='com.example.app' versionCode='1' versionName='1.2.3'" \
        "application-label:'My Application'"
}
adb() { printf 'adb %s\n' "$*"; }
fastboot() { printf 'fastboot %s\n' "$*"; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __stub_dir__="$(mktemp -d)"
    __image__="${__stub_dir__}/image.img"
    __apk__="${__stub_dir__}/app.apk"
    touch "${__image__}" "${__apk__}"
}

teardown() {
    rm -rf "${__stub_dir__}"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "bash ../../../src/shell/android/_flash_img.sh"
}

#--------------------------------------------------
# Flash / lock / wipe
#--------------------------------------------------

test_flash_img_should_flash_image_to_partition() {
    assert_equals \
        "fastboot --verbose flash boot $(realpath "${__image__}")" \
        "$(_flash_img "${__image__}" 'boot')"
}

test_flash_img_should_disable_verity_when_forced() {
    assert_equals \
        "fastboot --verbose --disable-verity --disable-verification flash boot $(realpath "${__image__}")" \
        "$(_flash_img "${__image__}" 'boot' 'true')"
}

test_flash_img_fails_when_device_is_missing() {
    __fastboot_missing__='true'

    assert_fails "_flash_img '${__image__}' 'boot'"
    assert_equals 'please reboot to bootloader' "$(_flash_img "${__image__}" 'boot' 2>&1)"
}

test_flash_img_fails_with_missing_arguments() {
    assert_fails "_flash_img"
    assert_equals '_flash_img: some mandatory parameter is missing' "$(_flash_img 2>&1)"
}

test_flash_img_fails_with_nonexistent_image() {
    assert_fails "_flash_img 'nonexistent.img' 'boot'"
}

test_flash_img_fails_with_too_many_arguments() {
    assert_fails "_flash_img 'a' 'b' 'c' 'd'"
    assert_equals '_flash_img: too many arguments (4)' "$(_flash_img 'a' 'b' 'c' 'd' 2>&1)"
}

test_fastboot_lock_should_lock_bootloader() {
    assert_equals \
        "fastboot oem lock
fastboot flashing lock" \
        "$(_fastboot_lock)"
}

test_fastboot_lock_fails_when_device_is_missing() {
    __fastboot_missing__='true'

    assert_fails "_fastboot_lock"
    assert_equals 'please reboot to bootloader' "$(_fastboot_lock 2>&1)"
}

test_fastboot_unlock_should_unlock_bootloader() {
    assert_equals \
        "fastboot oem unlock
fastboot flashing unlock
fastboot flashing unlock_critical" \
        "$(_fastboot_unlock)"
}

test_fastboot_unlock_fails_when_device_is_missing() {
    __fastboot_missing__='true'

    assert_fails "_fastboot_unlock"
}

test_fastboot_wipe_should_wipe_userdata() {
    assert_equals 'fastboot -w' "$(_fastboot_wipe)"
}

test_fastboot_wipe_fails_when_device_is_missing() {
    __fastboot_missing__='true'

    assert_fails "_fastboot_wipe"
}

test_toggle_active_slot_should_set_other_slot_active() {
    assert_equals 'fastboot set_active other' "$(_toggle_active_slot)"
}

test_toggle_active_slot_fails_when_device_is_missing() {
    __fastboot_missing__='true'

    assert_fails "_toggle_active_slot"
}

#--------------------------------------------------
# Reboot
#--------------------------------------------------

test_reboot_bootloader_should_use_adb_when_connected() {
    __adb_connected__='true'

    assert_equals 'adb reboot bootloader' "$(_reboot_bootloader)"
}

test_reboot_bootloader_should_use_fastboot_as_fallback() {
    assert_equals 'fastboot reboot bootloader' "$(_reboot_bootloader)"
}

test_reboot_bootloader_fails_when_no_device_is_connected() {
    __fastboot_missing__='true'

    assert_fails "_reboot_bootloader"
    assert_equals '"_reboot_bootloader" device not found.' "$(_reboot_bootloader 2>&1)"
}

test_reboot_recovery_should_use_adb_when_connected() {
    __adb_connected__='true'

    assert_equals 'adb reboot recovery' "$(_reboot_recovery)"
}

test_reboot_recovery_should_use_fastboot_as_fallback() {
    assert_equals 'fastboot reboot recovery' "$(_reboot_recovery)"
}

test_reboot_system_should_use_adb_when_connected() {
    __adb_connected__='true'

    assert_equals 'adb reboot system' "$(_reboot_system)"
}

test_reboot_system_should_use_fastboot_as_fallback() {
    assert_equals 'fastboot reboot' "$(_reboot_system)"
}

test_reboot_with_img_should_boot_image_temporarily() {
    assert_equals \
        "fastboot --verbose boot $(realpath "${__image__}")" \
        "$(_reboot_with_img "${__image__}")"
}

test_reboot_with_img_fails_when_device_is_missing() {
    __fastboot_missing__='true'

    assert_fails "_reboot_with_img '${__image__}'"
}

test_reboot_with_img_fails_with_missing_argument() {
    assert_fails "_reboot_with_img"
    assert_equals '_reboot_with_img: some mandatory parameter is missing' "$(_reboot_with_img 2>&1)"
}

test_reboot_with_img_fails_with_nonexistent_file() {
    assert_fails "_reboot_with_img 'nonexistent.img'"
}

#--------------------------------------------------
# APK metadata
#--------------------------------------------------

test_get_apk_label_should_return_application_label() {
    assert_equals 'My Application' "$(_get_apk_label "${__apk__}")"
}

test_get_apk_package_name_should_return_package_name() {
    assert_equals 'com.example.app' "$(_get_apk_package_name "${__apk__}")"
}

test_get_apk_version_should_return_version_name() {
    assert_equals '1.2.3' "$(_get_apk_version "${__apk__}")"
}

test_get_apk_label_fails_with_missing_argument() {
    assert_fails "_get_apk_label"
    assert_equals '_get_apk_label: some mandatory parameter is missing' "$(_get_apk_label 2>&1)"
}

test_get_apk_label_fails_with_nonexistent_file() {
    assert_fails "_get_apk_label 'nonexistent.apk'"
}

test_get_apk_package_name_fails_with_missing_argument() {
    assert_fails "_get_apk_package_name"
    assert_equals '_get_apk_package_name: some mandatory parameter is missing' "$(_get_apk_package_name 2>&1)"
}

test_get_apk_version_fails_with_missing_argument() {
    assert_fails "_get_apk_version"
    assert_equals '_get_apk_version: some mandatory parameter is missing' "$(_get_apk_version 2>&1)"
}
