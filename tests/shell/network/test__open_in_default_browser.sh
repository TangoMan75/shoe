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

src_file="../../../src/shell/network/_open_in_default_browser.sh"

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%b' "$1"; }
_echo_info() { :; }
_open() { printf 'xdg-open'; }
nohup() { printf 'nohup %s\n' "$*" > "${__nohup_output__}"; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __nohup_output__="$(mktemp)"
}

teardown() {
    rm -f "${__nohup_output__}"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------

test_open_in_default_browser_should_use_default_values() {
    _open_in_default_browser

    assert_equals 'nohup xdg-open http://127.0.0.1:80' "$(cat "${__nohup_output__}")"
}

test_open_in_default_browser_should_open_given_url() {
    _open_in_default_browser 'example.com' 8080 'https'

    assert_equals 'nohup xdg-open https://example.com:8080' "$(cat "${__nohup_output__}")"
}

test_open_in_default_browser_fails_with_too_many_arguments() {
    assert_fails "_open_in_default_browser 'a' 'b' 'c' 'd'"
    assert_equals "_open_in_default_browser: too many arguments (4)" "$(_open_in_default_browser 'a' 'b' 'c' 'd' 2>&1)"
}
