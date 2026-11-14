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

src_file="../../../src/shell/help/_print_usage.sh"

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%s' "$1"; }
_echo_info() {
    printf '%*s' "${2:-0}" ''
    printf '%b' "$1"
}
_echo_success() { printf '%b' "$1"; }
_echo_warning() { printf '%b' "$1"; }

_INFO=''
_SUCCESS=''
_WARNING=''
_DEFAULT=''

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------

test_print_usage_should_print_usage_and_options() {
    actual="$(_print_usage "../../../tests/fixtures/help_test.sh")"
    expected="$(printf "Usage:\n  sh help_test.sh <command> [--who 'World'] [--count 1] [--prefix] [--verbose] \n\n")"
    assert_equals "${expected}" "${actual}"
}

test_print_usage_fails_with_missing_argument() {
    assert_fails "_print_usage"
    assert_equals "_print_usage: some mandatory parameter is missing\n" "$(_print_usage 2>&1)"
}

test_print_usage_fails_with_nonexistent_file() {
    assert_fails "_print_usage 'nonexistent.sh'"
}

