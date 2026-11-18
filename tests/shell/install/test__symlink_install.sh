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

src_file="../../../src/shell/install/_symlink_install.sh"

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%b' "$1"; }
_echo_info() { :; }
sudo() { printf 'sudo %s\n' "$*"; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __stub_dir__="$(mktemp -d)"
    __script__="${__stub_dir__}/myscript.sh"
    printf '#!/bin/sh\n' > "${__script__}"
    chmod +x "${__script__}"
}

teardown() {
    rm -rf "${__stub_dir__}"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "bash ${src_file}"
}

#--------------------------------------------------
# Copy / symlink
#--------------------------------------------------

test_symlink_install_should_symlink_script_with_default_alias() {
    assert_equals \
        "sudo ln -s $(realpath "${__script__}") /usr/local/bin/myscript" \
        "$(_symlink_install "${__script__}")"
}

test_symlink_install_should_symlink_script_with_given_alias() {
    assert_equals \
        "sudo ln -s $(realpath "${__script__}") /usr/local/bin/my-alias" \
        "$(_symlink_install "${__script__}" 'my-alias')"
}

test_symlink_install_fails_with_missing_argument() {
    assert_fails "_symlink_install"
    assert_equals '_symlink_install some mandatory parameter is missing' "$(_symlink_install 2>&1)"
}

test_symlink_install_fails_with_nonexistent_file() {
    assert_fails "_symlink_install 'nonexistent.sh'"
}

test_symlink_install_fails_with_too_many_arguments() {
    assert_fails "_symlink_install 'a' 'b' 'c'"
    assert_equals '_symlink_install too many arguments (3)' "$(_symlink_install 'a' 'b' 'c' 2>&1)"
}
