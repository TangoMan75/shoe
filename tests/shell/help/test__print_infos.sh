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

src_file="../../../src/shell/help/_print_infos.sh"

source "${src_file}"
source "../../../src/shell/shoedoc/_get_script_shoedoc.sh"
source "../../../src/shell/shoedoc/_get_shoedoc_tag.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%s' "$1"; }
_echo_primary() {
    printf '%*s' "${2:-0}" ''
    printf '%b' "$1"
}
_echo_success() {
    printf '%*s' "${2:-0}" ''
    printf '%b' "$1"
    __padding__=$((${3:-0}-${#1}))
    if [ "${__padding__}" -gt 0 ]; then printf '%*s' "${__padding__}" ''; fi
}
_echo_warning() { printf '%b' "$1"; }

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------

test_print_infos_should_print_author_version_and_link() {
    actual="$(_print_infos "../../../tests/fixtures/reflexion_test.sh")"
    expected="$(printf 'Infos:\n  author  \"Matthias Morin\" <mat@tangoman.io>\n  version 0.1.0\n  link    https://github.com/TangoMan75/shoe\n\n')"
    assert_equals "${expected}" "${actual}"
}

test_print_infos_fails_with_missing_argument() {
    assert_fails "_print_infos"
    assert_equals "_print_infos: some mandatory parameter is missing\n" "$(_print_infos 2>&1)"
}

test_print_infos_fails_with_nonexistent_file() {
    assert_fails "_print_infos 'nonexistent.sh'"
}

test_print_infos_fails_with_too_many_arguments() {
    assert_fails "_print_infos 'a' 'b'"
    assert_equals "_print_infos: too many arguments (2)\n" "$(_print_infos 'a' 'b' 2>&1)"
}
