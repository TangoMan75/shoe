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

source "../../../src/shell/android/_is_apk_installed.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%b' "$1"; }
_is_device_connected_with_adb() { [ -z "${__adb_missing__:-}" ]; }
adb() {
    case "$*" in
        'shell cmd package path '*)
            printf '%s\n' "${__apk_path_output-}"
            ;;
        *)
            printf 'adb %s\n' "$*"
            ;;
    esac
}

#--------------------------------------------------
# Installed packages
#--------------------------------------------------

test_is_apk_installed_returns_true_when_package_exists() {
    __apk_path_output='/data/app/com.example/base.apk'

    assert "_is_apk_installed 'com.example.app'"
}

test_is_apk_installed_returns_false_when_package_is_missing() {
    __apk_path_output=''

    assert_fails "_is_apk_installed 'com.example.app'"
}

test_is_apk_installed_fails_when_device_is_missing() {
    __adb_missing__='true'

    assert_fails "_is_apk_installed 'com.example.app'"
    assert_equals 'device not found' "$(_is_apk_installed 'com.example.app' 2>&1)"
}

test_is_apk_installed_fails_with_missing_argument() {
    assert_fails "_is_apk_installed"
    assert_equals '_is_apk_installed: some mandatory parameter is missing' "$(_is_apk_installed 2>&1)"
}
