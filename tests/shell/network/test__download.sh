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

source "../../../src/shell/network/_download.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%b' "$1"; }
_echo_info() { :; }
_is_installed() { [ "$1" = "${__downloader__:-curl}" ]; }
curl() { printf '%s' "${__content__-downloaded}" > "$4"; }
wget() { printf '%s' "${__content__-downloaded}" > "$4"; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __stub_dir__="$(mktemp -d)"
}

teardown() {
    rm -rf "${__stub_dir__}"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "bash ../../../src/shell/network/_download.sh"
}

#--------------------------------------------------

test_download_should_download_file_with_curl() {
    __file__="${__stub_dir__}/file.txt"

    _download 'https://example.com/file.txt' "${__file__}"

    assert_equals 'downloaded' "$(cat "${__file__}")"
}

test_download_should_create_destination_folder() {
    __file__="${__stub_dir__}/nested/folder/file.txt"

    _download 'https://example.com/file.txt' "${__file__}"

    assert_equals 'downloaded' "$(cat "${__file__}")"
}

test_download_should_fallback_to_wget() {
    __downloader__='wget'
    __file__="${__stub_dir__}/file.txt"

    _download 'https://example.com/file.txt' "${__file__}"

    assert_equals 'downloaded' "$(cat "${__file__}")"
}

test_download_fails_when_no_downloader_is_available() {
    _is_installed() { return 1; }
    __file__="${__stub_dir__}/file.txt"
    __status__=0
    __output__="$(_download 'https://example.com/file.txt' "${__file__}" 2>&1)" || __status__=$?

    assert_equals 1 "${__status__}"
    assert_equals 'Neither curl nor wget is available for downloading files.' "${__output__}"
}

test_download_fails_when_downloaded_file_is_empty() {
    __content__=''
    __file__="${__stub_dir__}/file.txt"

    assert_fails "_download 'https://example.com/file.txt' '${__file__}'"
    assert_equals 'Downloaded file is invalid or not found.' "$(_download 'https://example.com/file.txt' "${__file__}" 2>&1)"
}

test_download_fails_when_downloaded_file_is_html_error_page() {
    __content__='<!DOCTYPE html><html></html>'
    __file__="${__stub_dir__}/file.txt"

    assert_fails "_download 'https://example.com/file.txt' '${__file__}'"
    assert_equals 'Downloaded file is invalid or not found.' "$(_download 'https://example.com/file.txt' "${__file__}" 2>&1)"
}

test_download_fails_with_missing_argument() {
    assert_fails "_download"
    assert_equals "_download: some mandatory parameter is missing" "$(_download 2>&1)"
}

test_download_fails_with_too_many_arguments() {
    assert_fails "_download 'a' 'b' 'c'"
    assert_equals "_download: too many arguments (3)" "$(_download 'a' 'b' 'c' 2>&1)"
}
