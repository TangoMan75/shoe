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

src_file="../../../src/shell/prompts/_select.sh"

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%s' "$1"; }
_echo_success() { printf '%b' "$1"; }
_echo_warning() { printf '%b' "$1"; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

_menu='1) one
2) two
3) three
Please select your choice : 
'

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------

test_select_should_return_selected_choice() {
    assert_equals "${_menu}two" "$(printf '2\n' | _select one two three)"
}

test_select_should_return_first_choice() {
    assert_equals "${_menu}one" "$(printf '1\n' | _select one two three)"
}

test_select_should_repeat_until_selection_is_valid() {
    assert_equals "${_menu}two" "$(printf '0\n4\n2\n' | _select one two three)"
}

test_select_should_handle_single_choice() {
    assert_equals "$(printf '1) one\nPlease select your choice : \none\n')" "$(printf '1\n' | _select one)"
}

test_select_fails_with_missing_argument() {
    assert_fails "_select"
    assert_equals "_select: some mandatory parameter is missing\n" "$(_select 2>&1)"
}
