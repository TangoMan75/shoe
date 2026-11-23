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

src_file="../../../src/shell/compatibility/_mktemp.sh"

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf 'error: %b' "$1"; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __old_tmpdir__="${TMPDIR-}"
    __tmp_dir__="$(mktemp -d)"
    TMPDIR="${__tmp_dir__}"
}

teardown() {
    TMPDIR="${__old_tmpdir__}"
    rm -rf "${__tmp_dir__}"
}

#--------------------------------------------------

test_mktemp_creates_a_file_in_tmpdir() {
    __file__="$(_mktemp 'shoe')"

    assert "test -f '${__file__}'"
    assert "printf '%s' '${__file__}' | grep -q '^${__tmp_dir__}/shoe\\.'"

    rm -f "${__file__}"
}

test_mktemp_creates_a_file_with_default_prefix() {
    __file__="$(_mktemp)"

    assert "test -f '${__file__}'"
    assert "printf '%s' '${__file__}' | grep -q '^${__tmp_dir__}/tmp\\.'"

    rm -f "${__file__}"
}

test_mktemp_creates_a_file_in_the_given_directory() {
    mkdir "${__tmp_dir__}/nested"

    __file__="$(_mktemp 'shoe' "${__tmp_dir__}/nested")"

    assert "test -f '${__file__}'"
    assert "printf '%s' '${__file__}' | grep -q '^${__tmp_dir__}/nested/shoe\\.'"

    rm -f "${__file__}"
}

test_mktemp_passes_a_complete_template_through() {
    __file__="$(_mktemp "${__tmp_dir__}/custom.XXXXXX")"

    assert "test -f '${__file__}'"
    assert "printf '%s' '${__file__}' | grep -q '^${__tmp_dir__}/custom\\.'"

    rm -f "${__file__}"
}

test_mktemp_fails_with_too_many_arguments() {
    assert_fails "_mktemp 'shoe' '${__tmp_dir__}' 'extra'"
    assert_equals \
        'error: _mktemp: too many arguments (3)' \
        "$(_mktemp 'shoe' "${__tmp_dir__}" 'extra' 2>&1)"
}

test_mktemp_fails_with_an_invalid_directory() {
    assert_fails "_mktemp 'shoe' '${__tmp_dir__}/missing'"
    assert_equals \
        'error: _mktemp: could not create temporary file' \
        "$(_mktemp 'shoe' "${__tmp_dir__}/missing" 2>&1)"
}
