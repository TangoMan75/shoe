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

src_file="../../../src/shell/install/_get_comspec.sh"

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%b' "$1"; }

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "bash ${src_file}"
}

#--------------------------------------------------
# Comspec
#--------------------------------------------------

test_get_comspec_should_return_public_commands_and_options() {
    __fixture__="$(realpath '../../../tests/fixtures/documentation_test.sh')"

    assert_equals 'public_command --public_option --public_flag ' "$(_get_comspec "${__fixture__}")"
}

test_get_comspec_fails_with_missing_argument() {
    assert_fails "_get_comspec"
    assert_equals '_get_comspec: some mandatory parameter is missing' "$(_get_comspec 2>&1)"
}

test_get_comspec_fails_with_nonexistent_file() {
    assert_fails "_get_comspec 'nonexistent.sh'"
}

test_get_comspec_fails_with_too_many_arguments() {
    assert_fails "_get_comspec 'a' 'b'"
    assert_equals '_get_comspec: too many arguments (2)' "$(_get_comspec 'a' 'b' 2>&1)"
}
