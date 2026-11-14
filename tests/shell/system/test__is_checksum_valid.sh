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

src_file="../../../src/shell/system/_is_checksum_valid.sh"

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_check_installed() { return 0; }
_echo_error() { printf '%s' "$1"; }
sha256sum() { printf '%s  %s\n' "${__checksum__}" "$1"; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __file__="$(mktemp)"
    printf 'content' > "${__file__}"
}

teardown() {
    rm -f "${__file__}"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------

test_is_checksum_valid_returns_true_for_matching_checksum() {
    __checksum__='abc123'

    assert "_is_checksum_valid '${__file__}' 'abc123'"
}

test_is_checksum_valid_returns_false_for_non_matching_checksum() {
    __checksum__='abc123'

    assert_fails "_is_checksum_valid '${__file__}' 'def456'"
}

test_is_checksum_valid_fails_with_missing_arguments() {
    assert_fails "_is_checksum_valid"
    assert_equals "_is_checksum_valid: some mandatory parameter is missing\n" "$(_is_checksum_valid 2>&1)"
}

test_is_checksum_valid_fails_with_missing_checksum() {
    assert_fails "_is_checksum_valid '${__file__}'"
    assert_equals "_is_checksum_valid: some mandatory parameter is missing\n" "$(_is_checksum_valid "${__file__}" 2>&1)"
}

test_is_checksum_valid_fails_with_nonexistent_file() {
    assert_fails "_is_checksum_valid 'nonexistent.txt' 'abc123'"
}

test_is_checksum_valid_fails_with_too_many_arguments() {
    assert_fails "_is_checksum_valid 'a' 'b' 'c'"
    assert_equals "_is_checksum_valid: too many arguments (3)\n" "$(_is_checksum_valid 'a' 'b' 'c' 2>&1)"
}
