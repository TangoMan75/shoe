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

source "../../../src/shell/files/_compress.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_danger() { printf '%b' "$1"; }
_echo_error() { printf '%b' "$1"; }
_echo_info() { :; }
_echo_primary() { printf '%b' "$1"; }
_echo_success() { printf '%b' "$1"; }
_echo_warning() { printf '%b' "$1"; }

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
# Compress
#--------------------------------------------------

test_compress_should_create_archive() {
    mkdir -p "${__tmp_dir__}/archives"
    printf 'content' > "${__tmp_dir__}/file.txt"

    _compress "${__tmp_dir__}/file.txt" "${__tmp_dir__}/archives" >/dev/null

    assert "ls '${__tmp_dir__}/archives'/file.txt.* >/dev/null 2>&1"
}

test_compress_recursive_should_create_one_archive_per_folder() {
    mkdir -p "${__tmp_dir__}/source/one" "${__tmp_dir__}/source/two" \
        "${__tmp_dir__}/archives"
    printf 'a' > "${__tmp_dir__}/source/one/a.txt"
    printf 'b' > "${__tmp_dir__}/source/two/b.txt"

    _compress "${__tmp_dir__}/source" "${__tmp_dir__}/archives" -r >/dev/null

    assert "ls '${__tmp_dir__}/archives'/one.* >/dev/null 2>&1"
    assert "ls '${__tmp_dir__}/archives'/two.* >/dev/null 2>&1"
}
