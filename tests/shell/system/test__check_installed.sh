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

src_file="../../../src/shell/system/_check_installed.sh"

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

basename() { printf 'test.sh'; }
_echo_error() { printf '%s' "$1"; }
_get_package_name() { printf 'package-name'; }
_is_installed() { [ -z "${__missing__:-}" ]; }

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------

test_check_installed_returns_success_when_command_is_installed() {
    unset __missing__

    assert "_check_installed 'my-command'"
    assert_equals '' "$(_check_installed 'my-command')"
}

test_check_installed_exits_with_error_when_command_is_missing() {
    __missing__='true'

    assert_fails "_check_installed 'my-command'"
    assert_equals \
        "\"test.sh\" requires my-command, try: 'sudo apt-get install -y package-name'\n" \
        "$(_check_installed 'my-command' 2>&1)"
}

test_check_installed_fails_with_missing_argument() {
    assert_fails "_check_installed"
    assert_equals "_check_installed: some mandatory parameter is missing\n" "$(_check_installed 2>&1)"
}

test_check_installed_fails_with_too_many_arguments() {
    assert_fails "_check_installed 'a' 'b' 'c'"
    assert_equals "_check_installed: too many arguments (3)\n" "$(_check_installed 'a' 'b' 'c' 2>&1)"
}
