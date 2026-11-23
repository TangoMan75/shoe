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

src_file="../../../src/shell/install/_remove_completion_autoload.sh"

source "../../../src/shell/compatibility/_sed_i.sh"
source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%b' "$1"; }
_echo_info() { :; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __stub_dir__="$(mktemp -d)"
    __config__="${__stub_dir__}/config"
    __script__="${__stub_dir__}/myscript.sh"
    printf '#!/bin/sh\n' > "${__script__}"
}

teardown() {
    rm -rf "${__stub_dir__}"
}

#--------------------------------------------------
# Remove autoload
#--------------------------------------------------

test_remove_completion_autoload_should_remove_autoload_block() {
    printf 'before\n###> my-alias\nsource /path/to/completion.sh\n###< my-alias\nafter\n' > "${__config__}"

    _remove_completion_autoload "${__config__}" 'my-alias'

    assert_equals "$(printf 'before\nafter')" "$(cat "${__config__}")"
}

test_remove_completion_autoload_should_leave_unrelated_content_unchanged() {
    printf 'before\nafter\n' > "${__config__}"

    _remove_completion_autoload "${__config__}" 'my-alias'

    assert_equals "$(printf 'before\nafter')" "$(cat "${__config__}")"
}

test_remove_completion_autoload_fails_with_missing_argument() {
    assert_fails "_remove_completion_autoload"
    assert_equals '_remove_completion_autoload: some mandatory parameter is missing' "$(_remove_completion_autoload 2>&1)"
}

test_remove_completion_autoload_fails_with_nonexistent_file() {
    assert_fails "_remove_completion_autoload 'nonexistent' 'my-alias'"
}

test_remove_completion_autoload_fails_with_too_many_arguments() {
    assert_fails "_remove_completion_autoload 'a' 'b' 'c'"
    assert_equals '_remove_completion_autoload: too many arguments (3)' "$(_remove_completion_autoload 'a' 'b' 'c' 2>&1)"
}
