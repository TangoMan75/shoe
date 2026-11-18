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

src_file="../../../src/shell/system/_get_package_name.sh"

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%s' "$1"; }

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------

test_get_package_name_should_map_android_tools() {
    assert_equals 'android-tools-adb' "$(_get_package_name adb)"
    assert_equals 'android-tools-adb' "$(_get_package_name aapt)"
    assert_equals 'android-tools-fastboot' "$(_get_package_name fastboot)"
}

test_get_package_name_should_map_snap() {
    assert_equals 'snapd' "$(_get_package_name snap)"
}

test_get_package_name_should_map_apache_utils() {
    assert_equals 'apache2-utils' "$(_get_package_name htpasswd)"
    assert_equals 'apache2-utils' "$(_get_package_name ab)"
}

test_get_package_name_should_map_nss_tools() {
    assert_equals 'libnss3-tools' "$(_get_package_name certutil)"
    assert_equals 'libnss3-tools' "$(_get_package_name pk12util)"
}

test_get_package_name_should_map_net_tools() {
    assert_equals 'net-tools' "$(_get_package_name ifconfig)"
    assert_equals 'net-tools' "$(_get_package_name route)"
}

test_get_package_name_should_return_input_when_unknown() {
    assert_equals 'unknown-command' "$(_get_package_name unknown-command)"
}

test_get_package_name_fails_with_missing_argument() {
    assert_fails "_get_package_name"
    assert_equals "_get_package_name: some mandatory parameter is missing\n" "$(_get_package_name 2>&1)"
}

test_get_package_name_fails_with_too_many_arguments() {
    assert_fails "_get_package_name 'a' 'b'"
    assert_equals "_get_package_name: too many arguments (2)\n" "$(_get_package_name 'a' 'b' 2>&1)"
}
