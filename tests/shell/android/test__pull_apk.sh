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
source "../../../src/shell/android/_pull_apk.sh"

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
# APK path / pull
#--------------------------------------------------

test_pull_apk_should_pull_apk_to_destination() {
    __destination__="${__stub_dir__}/output"
    mkdir -p "${__destination__}"
    _get_apk_path() { printf '/remote/com.example.app.apk'; }

    assert_equals \
        "adb pull /remote/com.example.app.apk $(realpath "${__destination__}")/com.example.app.apk" \
        "$(_pull_apk 'com.example.app' "${__destination__}")"
}

test_pull_apk_fails_when_device_is_missing() {
    __adb_missing__='true'

    assert_fails "_pull_apk 'com.example.app' '/tmp'"
}

test_pull_apk_fails_with_missing_arguments() {
    assert_fails "_pull_apk 'com.example.app'"
    assert_equals '_pull_apk: some mandatory parameter is missing' "$(_pull_apk 'com.example.app' 2>&1)"
}

test_pull_apk_fails_with_nonexistent_destination() {
    assert_fails "_pull_apk 'com.example.app' 'nonexistent'"
}

test_pull_apk_fails_with_an_invalid_package_name() {
    __destination__="${__stub_dir__}/output"
    mkdir -p "${__destination__}"
    _get_apk_path() { printf '/remote/com.example.app.apk'; }

    assert_fails "_pull_apk '../../etc/passwd' '${__destination__}'"
    assert_equals '_pull_apk: invalid package name "../../etc/passwd"' \
        "$(_pull_apk '../../etc/passwd' "${__destination__}" 2>&1)"
    assert_fails "[ -e '${__stub_dir__}/etc/passwd.apk' ]"
}

test_pull_apk_fails_when_the_apk_cannot_be_located() {
    __destination__="${__stub_dir__}/output"
    mkdir -p "${__destination__}"
    _get_apk_path() { return 1; }

    assert_fails "_pull_apk 'com.example.app' '${__destination__}'"
    assert_equals '_pull_apk: could not locate the apk for "com.example.app"' \
        "$(_pull_apk 'com.example.app' "${__destination__}" 2>&1)"
}
