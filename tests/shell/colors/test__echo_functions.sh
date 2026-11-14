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

colors_dir="../../../src/shell/colors"

source "${colors_dir}/_echo_primary.sh"
source "${colors_dir}/_echo_secondary.sh"
source "${colors_dir}/_echo_success.sh"
source "${colors_dir}/_echo_danger.sh"
source "${colors_dir}/_echo_warning.sh"
source "${colors_dir}/_echo_info.sh"
source "${colors_dir}/_echo_light.sh"
source "${colors_dir}/_echo_dark.sh"
source "${colors_dir}/_echo_error.sh"

#--------------------------------------------------
# Mock constants
#--------------------------------------------------

_DANGER=''
_DARK=''
_DEFAULT=''
_INFO=''
_LIGHT=''
_PRIMARY=''
_SECONDARY=''
_SUCCESS=''
_WARNING=''

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "bash ${colors_dir}/_echo_primary.sh"
}

#--------------------------------------------------

test_echo_primary_should_return_text() {
    assert_equals 'hello' "$(_echo_primary 'hello')"
}

test_echo_secondary_should_return_text() {
    assert_equals 'hello' "$(_echo_secondary 'hello')"
}

test_echo_success_should_return_text() {
    assert_equals 'hello' "$(_echo_success 'hello')"
}

test_echo_danger_should_return_text() {
    assert_equals 'hello' "$(_echo_danger 'hello')"
}

test_echo_warning_should_return_text() {
    assert_equals 'hello' "$(_echo_warning 'hello')"
}

test_echo_info_should_return_text() {
    assert_equals 'hello' "$(_echo_info 'hello')"
}

test_echo_light_should_return_text() {
    assert_equals 'hello' "$(_echo_light 'hello')"
}

test_echo_dark_should_return_text() {
    assert_equals 'hello' "$(_echo_dark 'hello')"
}

test_echo_error_should_prefix_message_with_error() {
    assert_equals 'error: boom' "$(_echo_error 'boom' 2>&1)"
}

test_echo_functions_should_indent_text() {
    assert_equals '  hello' "$(_echo_primary 'hello' 2)"
    assert_equals '    hello' "$(_echo_secondary 'hello' 4)"
}

test_echo_functions_should_pad_text() {
    assert_equals 'hello     ' "$(_echo_primary 'hello' 0 10)"
    assert_equals '  hello     ' "$(_echo_primary 'hello' 2 10)"
}

test_echo_functions_should_not_pad_text_longer_than_padding() {
    assert_equals 'hello' "$(_echo_primary 'hello' 0 2)"
}

test_echo_functions_should_interpret_backslash_escapes() {
    assert_equals "$(printf 'hello\nworld')" "$(_echo_primary 'hello\nworld')"
}

test_echo_error_should_write_to_stderr() {
    assert_equals '' "$(_echo_error 'boom' 2>/dev/null)"
}
