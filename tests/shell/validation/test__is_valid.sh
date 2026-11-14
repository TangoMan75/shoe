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

src_file="../../../src/shell/validation/_is_valid.sh"

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

test_is_valid_should_return_true_for_matching_pattern() {
    assert "_is_valid '12345' '/^[0-9]+$/'"
}

test_is_valid_should_return_false_for_non_matching_pattern() {
    assert_fails "_is_valid 'abc' '/^[0-9]+$/'"
}

test_is_valid_should_accept_pattern_without_delimiters() {
    assert "_is_valid 'abc' '^[a-z]+$'"
}

test_is_valid_should_return_true_for_empty_pattern() {
    assert "_is_valid 'anything' ''"
}

test_is_valid_should_validate_email_like_pattern() {
    assert "_is_valid 'user@example.com' '/^[a-z]+@[a-z]+\.[a-z]+$/'"
    assert_fails "_is_valid 'user@example' '/^[a-z]+@[a-z]+\.[a-z]+$/'"
}

test_is_valid_fails_with_missing_arguments() {
    assert_fails "_is_valid"
    assert_equals "_is_valid: some mandatory parameter is missing\n" "$(_is_valid 2>&1)"
}

test_is_valid_fails_with_missing_pattern() {
    assert_fails "_is_valid 'value'"
    assert_equals "_is_valid: some mandatory parameter is missing\n" "$(_is_valid 'value' 2>&1)"
}

test_is_valid_fails_with_too_many_arguments() {
    assert_fails "_is_valid 'a' 'b' 'c'"
    assert_equals "_is_valid: too many arguments (3)\n" "$(_is_valid 'a' 'b' 'c' 2>&1)"
}
