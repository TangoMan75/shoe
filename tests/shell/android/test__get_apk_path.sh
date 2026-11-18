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

source "../../../src/shell/android/_get_apk_path.sh"

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

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "bash ../../../src/shell/android/_get_apk_path.sh"
}

#--------------------------------------------------
# APK path / pull
#--------------------------------------------------

test_get_apk_path_should_return_package_path() {
    __apk_path_output='package:/data/app/com.example/base.apk'

    assert_equals '/data/app/com.example/base.apk' "$(_get_apk_path 'com.example.app')"
}

test_get_apk_path_fails_when_device_is_missing() {
    __adb_missing__='true'

    assert_fails "_get_apk_path 'com.example.app'"
}

test_get_apk_path_fails_with_missing_argument() {
    assert_fails "_get_apk_path"
    assert_equals '_get_apk_path: some mandatory parameter is missing' "$(_get_apk_path 2>&1)"
}
