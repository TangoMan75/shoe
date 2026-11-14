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

src_file="../../../src/shell/compatibility/_readlink.sh"

source "${src_file}"

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

_stub_exit() {
    printf '#!/bin/sh\nexit %s\n' "$2" > "${__stub_dir__}/$1"
    chmod +x "${__stub_dir__}/$1"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------

test_readlink_returns_realpath() {
    _stub realpath
    PATH="${__stub_dir__}"

    assert_equals 'realpath' "$(_readlink)"
}

test_readlink_returns_greadlink_with_follow() {
    _stub greadlink
    PATH="${__stub_dir__}"

    assert_equals 'greadlink -f' "$(_readlink)"
}

test_readlink_returns_readlink_with_follow() {
    _stub_exit readlink 0
    PATH="${__stub_dir__}"

    assert_equals 'readlink -f' "$(_readlink)"
}

test_readlink_fails_when_readlink_has_no_follow_support() {
    _stub_exit readlink 1
    PATH="${__stub_dir__}"
    __status__=0
    __output__="$(_readlink 2>&1)" || __status__=$?
    PATH="${__old_path__}"

    assert_equals 1 "${__status__}"
    assert_equals \
        'error: _readlink: no canonical path command found' \
        "${__output__}"
}

test_readlink_fails_when_no_command_found() {
    PATH="${__stub_dir__}"
    __status__=0
    __output__="$(_readlink 2>&1)" || __status__=$?
    PATH="${__old_path__}"

    assert_equals 1 "${__status__}"
    assert_equals \
        'error: _readlink: no canonical path command found' \
        "${__output__}"
}

