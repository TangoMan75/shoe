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

source "../../../src/shell/android/_adb_connect.sh"
source "../../../src/shell/android/_adb_sideload.sh"
source "../../../src/shell/android/_adb_start_server.sh"
source "../../../src/shell/android/_get_apk_path.sh"
source "../../../src/shell/android/_install_apk.sh"
source "../../../src/shell/android/_is_apk_installed.sh"
source "../../../src/shell/android/_list_installed_apks.sh"
source "../../../src/shell/android/_pull_apk.sh"
source "../../../src/shell/android/_remove_apk.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_check_installed() { return 0; }
_echo_error() { printf '%b' "$1"; }
_echo_info() { :; }
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
    assert_status_code 0 "bash ../../../src/shell/android/_adb_connect.sh"
}

#--------------------------------------------------
# Connect / server
#--------------------------------------------------

test_adb_connect_should_connect_with_default_port() {
    assert_equals 'adb connect 192.168.1.2:5555' "$(_adb_connect '192.168.1.2')"
}

test_adb_connect_should_connect_with_given_port() {
    assert_equals 'adb connect 192.168.1.2:4444' "$(_adb_connect '192.168.1.2' 4444)"
}

test_adb_connect_fails_with_missing_argument() {
    assert_fails "_adb_connect"
    assert_equals '_adb_connect: some mandatory parameter is missing' "$(_adb_connect 2>&1)"
}

test_adb_connect_fails_with_too_many_arguments() {
    assert_fails "_adb_connect 'a' 'b' 'c'"
    assert_equals '_adb_connect: too many arguments (3)' "$(_adb_connect 'a' 'b' 'c' 2>&1)"
}

test_adb_start_server_should_start_server() {
    assert_equals 'adb start-server' "$(_adb_start_server)"
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

test_remove_apk_should_uninstall_package() {
    assert_equals 'adb uninstall com.example.app' "$(_remove_apk 'com.example.app')"
}

test_remove_apk_should_uninstall_package_for_user_when_forced() {
    assert_equals \
        'adb shell cmd package uninstall --user 0 com.example.app' \
        "$(_remove_apk 'com.example.app' 'true')"
}

test_remove_apk_fails_when_device_is_missing() {
    __adb_missing__='true'

    assert_fails "_remove_apk 'com.example.app'"
    assert_equals 'device not found' "$(_remove_apk 'com.example.app' 2>&1)"
}

test_remove_apk_fails_with_missing_argument() {
    assert_fails "_remove_apk"
    assert_equals '_remove_apk: some mandatory parameter is missing' "$(_remove_apk 2>&1)"
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

test_list_installed_apks_should_list_packages() {
    assert_equals 'adb shell cmd package list packages -f' "$(_list_installed_apks)"
}

test_list_installed_apks_fails_when_device_is_missing() {
    __adb_missing__='true'

    assert_fails "_list_installed_apks"
    assert_equals 'device not found' "$(_list_installed_apks 2>&1)"
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
