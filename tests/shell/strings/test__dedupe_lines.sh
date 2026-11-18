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

src_file="../../../src/shell/strings/_dedupe_lines.sh"

source "../../../src/shell/compatibility/_sed_i.sh"
source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%s' "$1"; }
_echo_info() { :; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __tmp_dir__="$(mktemp -d)"
    __source__="${__tmp_dir__}/source.txt"
    __target__="${__tmp_dir__}/target.txt"
}

teardown() {
    rm -rf "${__tmp_dir__}"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "bash ${src_file}"
}

#--------------------------------------------------

test_dedupe_lines_should_remove_matching_lines_from_target() {
    printf 'remove-me\nfoo\n' > "${__source__}"
    printf 'keep\nremove-me\nfoo\nbar\n' > "${__target__}"

    _dedupe_lines "${__source__}" "${__target__}"

    assert_equals "$(printf 'keep\nbar')" "$(cat "${__target__}")"
}

test_dedupe_lines_should_leave_target_unchanged_when_nothing_matches() {
    printf 'absent\n' > "${__source__}"
    printf 'keep\nbar\n' > "${__target__}"

    _dedupe_lines "${__source__}" "${__target__}"

    assert_equals "$(printf 'keep\nbar')" "$(cat "${__target__}")"
}

test_dedupe_lines_fails_with_missing_argument() {
    assert_fails "_dedupe_lines"
    assert_equals "_dedupe_lines: some mandatory parameter is missing\n" "$(_dedupe_lines 2>&1)"
}

test_dedupe_lines_fails_with_missing_target() {
    assert_fails "_dedupe_lines '${__source__}'"
    assert_equals "_dedupe_lines: some mandatory parameter is missing\n" "$(_dedupe_lines "${__source__}" 2>&1)"
}

test_dedupe_lines_fails_with_nonexistent_source() {
    assert_fails "_dedupe_lines 'nonexistent.txt' '${__target__}'"
}

test_dedupe_lines_fails_with_nonexistent_target() {
    assert_fails "_dedupe_lines '${__source__}' 'nonexistent.txt'"
}

test_dedupe_lines_fails_with_too_many_arguments() {
    assert_fails "_dedupe_lines 'a' 'b' 'c'"
    assert_equals "_dedupe_lines: too many arguments (3)\n" "$(_dedupe_lines 'a' 'b' 'c' 2>&1)"
}
