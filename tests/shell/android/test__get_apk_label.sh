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

source "../../../src/shell/android/_get_apk_label.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_check_installed() { return 0; }
_echo_error() { printf '%b' "$1"; }
aapt() {
    printf '%s\n' \
        "package: name='com.example.app' versionCode='1' versionName='1.2.3'" \
        "application-label:'My Application'"
}

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
# APK metadata
#--------------------------------------------------

test_get_apk_label_should_return_application_label() {
    assert_equals 'My Application' "$(_get_apk_label "${__apk__}")"
}

test_get_apk_label_fails_with_missing_argument() {
    assert_fails "_get_apk_label"
    assert_equals '_get_apk_label: some mandatory parameter is missing' "$(_get_apk_label 2>&1)"
}

test_get_apk_label_fails_with_nonexistent_file() {
    assert_fails "_get_apk_label 'nonexistent.apk'"
}
