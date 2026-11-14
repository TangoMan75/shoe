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

src_file="../../../src/shell/help/_print_options.sh"

source "${src_file}"
source "../../../src/shell/reflexion/_get_options.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%s' "$1"; }
_echo_info() { printf '%b' "$1"; }
_echo_primary() { printf '%b' "$1"; }
_echo_success() { printf '%b' "$1"; }
_echo_warning() { printf '%b' "$1"; }

_DEFAULT=''
_EOL='\n'
_INFO=''
_PRIMARY=''
_SUCCESS=''
_WARNING=''

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------

test_print_options_should_print_first_line_of_multiline_description() {
    actual="$(_print_options "../../../tests/fixtures/help_test.sh")"
    expected="Options:
  --who        The recipient's name  /^[a-zA-Z -]+$/ (default: 'World')
  --count      The repetition count  /^[1-9][0-9]?$/ (default: 1)"
    assert_equals "${expected}" "${actual}"
}

test_print_options_should_read_classic_and_inline_constraints() {
    actual="$(_print_options "../../../tests/fixtures/extended_annotations.sh")"
    expected="Options:
  --default_name Default recipient name  /^[a-zA-Z-]+$/ (default: \"World\")
  --legacy_name Classic recipient name  /^[a-z]+$/ (default: \"World\")
  --inline_name Inline recipient name  /^[0-9]+$/ (default: \"123\")
  --plain_name Plain recipient name (default: \"anything\")"
    assert_equals "${expected}" "${actual}"
}

test_print_options_fails_with_missing_argument() {
    assert_fails "$(_print_options)"
    assert_equals "_print_options: some mandatory parameter is missing\n" "$(_print_options)"
}

test_print_options_fails_with_nonexistent_file() {
    assert_fails "$(_print_options 'nonexistent.sh')"
}
