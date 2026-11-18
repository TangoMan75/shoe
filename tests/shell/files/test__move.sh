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

src_file="../../../src/shell/files/_move.sh"

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
}

teardown() {
    rm -rf "${__tmp_dir__}"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "bash ${src_file}"
}

#--------------------------------------------------

test_move_should_move_file_and_create_destination_folder() {
    __source__="${__tmp_dir__}/file.txt"
    __destination__="${__tmp_dir__}/nested/destination"
    printf 'content' > "${__source__}"

    _move "${__source__}" "${__destination__}"

    assert_equals 'content' "$(cat "${__destination__}/file.txt")"
    assert_fails "[ -e '${__source__}' ]"
}

test_move_should_merge_folder_into_existing_destination_and_remove_source() {
    __source__="${__tmp_dir__}/source"
    __destination__="${__tmp_dir__}/destination"
    mkdir -p "${__source__}" "${__destination__}"
    printf 'moved' > "${__source__}/file.txt"
    printf 'kept' > "${__destination__}/existing.txt"

    _move "${__source__}" "${__destination__}"

    assert_equals 'moved' "$(cat "${__destination__}/file.txt")"
    assert_equals 'kept' "$(cat "${__destination__}/existing.txt")"
    assert_fails "[ -d '${__source__}' ]"
}

test_move_should_keep_dotfiles_when_merging_folders() {
    __source__="${__tmp_dir__}/source"
    __destination__="${__tmp_dir__}/destination"
    mkdir -p "${__source__}" "${__destination__}"
    printf 'hidden' > "${__source__}/.hidden"

    _move "${__source__}" "${__destination__}"

    assert_equals 'hidden' "$(cat "${__destination__}/.hidden")"
}

test_move_fails_with_missing_arguments() {
    assert_fails "_move"
    assert_equals "_move: some mandatory parameter is missing\n" "$(_move 2>&1)"
}

test_move_fails_with_missing_destination() {
    assert_fails "_move '${__tmp_dir__}'"
    assert_equals "_move: some mandatory parameter is missing\n" "$(_move "${__tmp_dir__}" 2>&1)"
}

test_move_fails_with_nonexistent_source() {
    assert_fails "_move '${__tmp_dir__}/nonexistent' '${__tmp_dir__}/destination'"
}

test_move_fails_with_too_many_arguments() {
    assert_fails "_move 'a' 'b' 'c'"
    assert_equals "_move: too many arguments (3)\n" "$(_move 'a' 'b' 'c' 2>&1)"
}
