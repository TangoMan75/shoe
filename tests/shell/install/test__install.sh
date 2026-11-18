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

src_file="../../../src/shell/install/_install.sh"

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%b' "$1"; }
_echo_info() { :; }
_is_installed() { return 1; }
_copy_install() { printf 'copy:%s:%s\n' "$1" "$2"; }
_generate_autocomplete() { printf 'autocomplete:%s:%s\n' "$1" "$2"; }
_generate_global_autocomplete() { printf 'global-autocomplete:%s:%s\n' "$1" "$2"; }
_set_completion_autoload() { printf 'autoload:%s:%s:%s\n' "$1" "$2" "$3"; }
_symlink_install() { printf 'symlink:%s:%s\n' "$1" "$2"; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __stub_dir__="$(mktemp -d)"
    __script__="${__stub_dir__}/myscript.sh"
    printf '#!/bin/sh\n' > "${__script__}"
}

teardown() {
    rm -rf "${__stub_dir__}"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "bash ${src_file}"
}

#--------------------------------------------------
# Install
#--------------------------------------------------

test_install_should_symlink_script_and_generate_autocomplete() {
    assert_equals \
        "symlink:$(realpath "${__script__}"):myscript
autocomplete:$(realpath "${__script__}"):myscript" \
        "$(_install "${__script__}")"
}

test_install_should_copy_script_and_generate_global_autocomplete() {
    assert_equals \
        "copy:$(realpath "${__script__}"):my-alias
global-autocomplete:$(realpath "${__script__}"):my-alias" \
        "$(_install "${__script__}" 'my-alias' 'true')"
}

test_install_fails_with_missing_argument() {
    assert_fails "_install"
    assert_equals '_install: some mandatory parameter is missing' "$(_install 2>&1)"
}

test_install_fails_with_nonexistent_file() {
    assert_fails "_install 'nonexistent.sh'"
}

test_install_fails_with_too_many_arguments() {
    assert_fails "_install 'a' 'b' 'c' 'd'"
    assert_equals '_install: too many arguments (4)' "$(_install 'a' 'b' 'c' 'd' 2>&1)"
}
