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

source "../../../src/shell/files/_clean_folder.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%b' "$1"; }
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
# Clean folder
#--------------------------------------------------

test_clean_folder_should_remove_junk_files_and_folders() {
    mkdir -p "${__tmp_dir__}/junk/__MACOSX" "${__tmp_dir__}/junk/__pycache__"
    printf 'x' > "${__tmp_dir__}/junk/Thumbs.db"
    printf 'x' > "${__tmp_dir__}/junk/desktop.ini"
    printf 'x' > "${__tmp_dir__}/junk/file.log"
    printf 'x' > "${__tmp_dir__}/junk/.DS_Store"
    printf 'keep' > "${__tmp_dir__}/junk/keep.txt"

    _clean_folder "${__tmp_dir__}/junk"

    assert "test ! -d '${__tmp_dir__}/junk/__MACOSX'"
    assert "test ! -d '${__tmp_dir__}/junk/__pycache__'"
    assert "test ! -f '${__tmp_dir__}/junk/Thumbs.db'"
    assert "test ! -f '${__tmp_dir__}/junk/desktop.ini'"
    assert "test ! -f '${__tmp_dir__}/junk/file.log'"
    assert "test ! -f '${__tmp_dir__}/junk/.DS_Store'"
    assert "test -f '${__tmp_dir__}/junk/keep.txt'"
}
