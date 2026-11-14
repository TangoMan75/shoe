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

src_file="../../../src/shell/compatibility/_open.sh"

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

## Mock _os_type so tests do not depend on the host system
_os_type() {
    printf '%s' "${__os_type__:-linux}"
}

__os_type__='linux'

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------
# Handlers
#--------------------------------------------------

test_open_returns_start_for_cygwin() {
    __os_type__='cygwin'
    assert_equals 'start' "$(_open)"
}

test_open_returns_start_for_msys() {
    __os_type__='msys'
    assert_equals 'start' "$(_open)"
}

test_open_returns_open_for_darwin() {
    __os_type__='darwin'
    assert_equals 'open' "$(_open)"
}

test_open_returns_xdg_open_for_linux() {
    __os_type__='linux'
    assert_equals 'xdg-open' "$(_open)"
}

#--------------------------------------------------
# Errors
#--------------------------------------------------

test_open_fails_when_os_type_is_unknown() {
    __os_type__=''
    assert_fails "$(_open)"
}

test_open_fails_for_unhandled_os_type() {
    __os_type__='bsd'
    assert_fails "$(_open)"
    assert_equals \
        'error: _open: no default handler for os type: "bsd"' \
        "$(_open 2>&1)"
}
