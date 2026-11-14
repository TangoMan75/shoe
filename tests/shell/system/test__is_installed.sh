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

src_file="../../../src/shell/system/_is_installed.sh"

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%s' "$1"; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __old_path__="${PATH}"
    __stub_dir__="$(mktemp -d)"
}

teardown() {
    PATH="${__old_path__}"
    rm -rf "${__stub_dir__}"
}

_stub() {
    printf '#!/bin/sh\nexit 0\n' > "${__stub_dir__}/$1"
    chmod +x "${__stub_dir__}/$1"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------

test_is_installed_returns_true_for_executable_command() {
    _stub my-command
    PATH="${__stub_dir__}:${__old_path__}"

    assert "_is_installed my-command"
}

test_is_installed_returns_false_for_missing_command() {
    assert_fails "_is_installed my-nonexistent-command-xyz"
}

test_is_installed_returns_false_for_non_executable_file() {
    printf '#!/bin/sh\n' > "${__stub_dir__}/not-executable"
    PATH="${__stub_dir__}:${__old_path__}"

    assert_fails "_is_installed not-executable"
}

test_is_installed_fails_with_missing_argument() {
    assert_fails "_is_installed"
    assert_equals "_is_installed: some mandatory parameter is missing\n" "$(_is_installed 2>&1)"
}

test_is_installed_fails_with_too_many_arguments() {
    assert_fails "_is_installed 'a' 'b'"
    assert_equals "_is_installed: too many arguments (2)\n" "$(_is_installed 'a' 'b' 2>&1)"
}
