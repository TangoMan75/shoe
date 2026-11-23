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

source "../../../src/shell/android/_reboot_with_img.sh"

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
# Reboot
#--------------------------------------------------

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
