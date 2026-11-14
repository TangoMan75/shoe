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

src_file="../../../src/shell/files/_extract.sh"

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_check_installed() { return 0; }
_echo_error() { printf '%s' "$1"; }
_echo_info() { :; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __tmp_dir__="$(mktemp -d)"
}

teardown() {
    rm -rf "${__tmp_dir__}"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "bash ${src_file}"
}

#--------------------------------------------------

test_extract_should_extract_tar_gz_archive() {
    __source_dir__="${__tmp_dir__}/source"
    __destination__="${__tmp_dir__}/destination"
    mkdir -p "${__source_dir__}" "${__destination__}"
    printf 'content' > "${__source_dir__}/file.txt"
    tar -czf "${__tmp_dir__}/archive.tar.gz" -C "${__source_dir__}" file.txt

    _extract "${__tmp_dir__}/archive.tar.gz" "${__destination__}" >/dev/null

    assert_equals 'content' "$(cat "${__destination__}/file.txt")"
}

test_extract_should_extract_zip_archive() {
    __destination__="${__tmp_dir__}/destination"
    mkdir -p "${__destination__}"
    printf 'archive' > "${__tmp_dir__}/archive.zip"

    unzip() { printf 'content' > "${__tmp_dir__}/destination/file.txt"; }
    _extract "${__tmp_dir__}/archive.zip" "${__destination__}"
    unset -f unzip

    assert_equals 'content' "$(cat "${__destination__}/file.txt")"
}

test_extract_should_report_unsupported_archive_format() {
    printf 'archive' > "${__tmp_dir__}/archive.rar"

    assert_equals \
        'Unsupported archive format "rar".\n' \
        "$(_extract "${__tmp_dir__}/archive.rar" "${__tmp_dir__}" 2>&1)"
}

test_extract_fails_with_missing_argument() {
    assert_fails "_extract"
    assert_equals "_extract: some mandatory parameter is missing\n" "$(_extract 2>&1)"
}

test_extract_fails_with_nonexistent_file() {
    assert_fails "_extract 'nonexistent.tar.gz'"
}

test_extract_fails_with_too_many_arguments() {
    assert_fails "_extract 'a' 'b' 'c'"
    assert_equals "_extract: too many arguments (3)\n" "$(_extract 'a' 'b' 'c' 2>&1)"
}
