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

source "../../../src/shell/android/_adb_sideload.sh"

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
    assert_status_code 0 "bash ../../../src/shell/android/_adb_sideload.sh"
}

#--------------------------------------------------
# Sideload
#--------------------------------------------------

test_adb_sideload_should_sideload_file() {
    __file__="${__stub_dir__}/update.zip"
    touch "${__file__}"

    assert_equals "adb sideload $(realpath "${__file__}")" "$(_adb_sideload "${__file__}")"
}

test_adb_sideload_fails_when_device_is_missing() {
    __adb_missing__='true'

    assert_fails "_adb_sideload 'file.zip'"
    assert_equals 'device not found' "$(_adb_sideload 'file.zip' 2>&1)"
}

test_adb_sideload_fails_with_missing_argument() {
    assert_fails "_adb_sideload"
    assert_equals '_adb_sideload: some mandatory parameter is missing' "$(_adb_sideload 2>&1)"
}

test_adb_sideload_fails_with_nonexistent_file() {
    assert_fails "_adb_sideload 'nonexistent.zip'"
}
