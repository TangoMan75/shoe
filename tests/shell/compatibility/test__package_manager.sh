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

src_file="../../../src/shell/compatibility/_package_manager.sh"

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_os_type() {
    printf '%s' "${__os_type__:-linux}"
}

_is_termux() {
    return "${__is_termux__:-1}"
}

__os_type__='linux'
__is_termux__=1

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __old_path__="${PATH}"
    __stub_dir__="$(mktemp -d)"
}

teardown() {
    PATH="${__old_path__}"
    rm -rf "${__stub_dir__}"
}

_stub() {
    printf '#!/bin/sh\nexit 0\n' > "${__stub_dir__}/$1"
    chmod +x "${__stub_dir__}/$1"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------
# Operating systems
#--------------------------------------------------

test_package_manager_returns_pkg_for_bsd() {
    __os_type__='bsd'

    assert_equals 'pkg' "$(_package_manager)"
}

test_package_manager_returns_apt_cyg_for_cygwin() {
    __os_type__='cygwin'

    assert_equals 'apt-cyg' "$(_package_manager)"
}

test_package_manager_returns_brew_for_darwin() {
    __os_type__='darwin'

    assert_equals 'brew' "$(_package_manager)"
}

test_package_manager_returns_pacman_for_msys() {
    __os_type__='msys'

    assert_equals 'pacman' "$(_package_manager)"
}

#--------------------------------------------------
# Linux
#--------------------------------------------------

test_package_manager_returns_pkg_for_termux() {
    __os_type__='linux'
    __is_termux__=0

    assert_equals 'pkg' "$(_package_manager)"
}

test_package_manager_returns_first_installed_manager() {
    _stub apt
    _stub dnf
    PATH="${__stub_dir__}"
    __is_termux__=1

    assert_equals 'apt' "$(_package_manager)"
}

test_package_manager_returns_apk_when_available() {
    _stub apk
    PATH="${__stub_dir__}"
    __is_termux__=1

    assert_equals 'apk' "$(_package_manager)"
}

test_package_manager_fails_when_no_manager_is_installed() {
    PATH="${__stub_dir__}"
    __is_termux__=1
    __status__=0
    __output__="$(_package_manager 2>&1)" || __status__=$?
    PATH="${__old_path__}"

    assert_equals 1 "${__status__}"
    assert_equals \
        'error: _package_manager: no package manager found' \
        "${__output__}"
}

#--------------------------------------------------
# Errors
#--------------------------------------------------

test_package_manager_fails_when_os_type_is_unknown() {
    __os_type__=''

    assert_fails "$(_package_manager)"
}

