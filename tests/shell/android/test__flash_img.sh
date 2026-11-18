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

source "../../../src/shell/android/_flash_img.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%b' "$1"; }
_echo_info() { :; }
_is_device_connected_with_fastboot() { [ -z "${__fastboot_missing__:-}" ]; }
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
