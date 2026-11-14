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

src_file="../../../src/shell/system/_remove.sh"

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%s' "$1"; }
_echo_info() { :; }
_get_package_name() { printf '%s' "$1"; }
_is_installed() { [ "$1" != 'missing-manager' ]; }
_package_manager() { printf 'apt'; }
sudo() { printf 'sudo %s\n' "$*"; }

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------

test_remove_does_nothing_when_command_is_not_installed() {
    _is_installed() { return 1; }

    assert "_remove 'my-command'"
    assert_equals '' "$(_remove 'my-command')"
}

test_remove_uses_default_package_manager() {
    assert_equals 'sudo apt remove --yes my-command' "$(_remove 'my-command')"
}

test_remove_uses_provided_package_manager() {
    assert_equals 'sudo apt-get remove --assume-yes my-command' "$(_remove 'my-command' apt-get)"
    assert_equals 'sudo dnf remove --assumeyes --nogpgcheck -y my-command' "$(_remove 'my-command' dnf)"
}

test_remove_exits_with_error_when_package_manager_is_missing() {
    assert_fails "_remove 'my-command' 'missing-manager'"
    assert_equals \
        '_remove "missing-manager" package manager not found!\n' \
        "$(_remove 'my-command' 'missing-manager' 2>&1)"
}

test_remove_fails_with_missing_argument() {
    assert_fails "_remove"
    assert_equals "_remove: some mandatory parameter is missing\n" "$(_remove 2>&1)"
}

test_remove_fails_with_too_many_arguments() {
    assert_fails "_remove 'a' 'b' 'c'"
    assert_equals "_remove: too many arguments (3)\n" "$(_remove 'a' 'b' 'c' 2>&1)"
}
