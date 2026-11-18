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

source "../../../src/shell/android/_install_apk.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%b' "$1"; }
_echo_info() { :; }
_is_device_connected_with_adb() { [ -z "${__adb_missing__:-}" ]; }
adb() { printf 'adb %s\n' "$*"; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __stub_dir__="$(mktemp -d)"
}

teardown() {
    rm -rf "${__stub_dir__}"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "bash ../../../src/shell/android/_install_apk.sh"
}

#--------------------------------------------------
# Install / remove
#--------------------------------------------------

test_install_apk_should_install_apk() {
    __file__="${__stub_dir__}/app.apk"
    touch "${__file__}"

    assert_equals "adb install -g $(realpath "${__file__}")" "$(_install_apk "${__file__}")"
}

test_install_apk_should_replace_application_when_forced() {
    __file__="${__stub_dir__}/app.apk"
    touch "${__file__}"

    assert_equals "adb install -r -g $(realpath "${__file__}")" "$(_install_apk "${__file__}" 'true')"
}

test_install_apk_fails_when_device_is_missing() {
    __adb_missing__='true'

    assert_fails "_install_apk 'app.apk'"
    assert_equals 'device not found' "$(_install_apk 'app.apk' 2>&1)"
}

test_install_apk_fails_with_missing_argument() {
    assert_fails "_install_apk"
    assert_equals '_install_apk: some mandatory parameter is missing' "$(_install_apk 2>&1)"
}

test_install_apk_fails_with_nonexistent_file() {
    assert_fails "_install_apk 'nonexistent.apk'"
}
