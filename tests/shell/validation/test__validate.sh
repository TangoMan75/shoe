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

src_file="../../../src/shell/validation/_validate.sh"

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%s' "$1"; }
_get_constraint() { printf '%s' "${__constraint__:-}"; }
_is_valid() { [ "$1" = "$__expected_value__" ]; }

__constraint__=''
__expected_value__=''

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------

test_validate_should_pass_with_matching_constraint() {
    __expected_value__='12345'

    assert "_validate 'count=12345' '/^[0-9]+$/'"
}

test_validate_should_exit_with_error_for_invalid_value() {
    __expected_value__='different'

    assert_fails "_validate 'count=abc' '/^[0-9]+$/'"
    assert_equals \
        "invalid \"count\", expected \"/^[0-9]+$/\", \"abc\" given\n" \
        "$(_validate 'count=abc' '/^[0-9]+$/' 2>&1)"
}

test_validate_should_read_constraint_from_script_when_omitted() {
    __constraint__='/^[a-z]+$/'
    __expected_value__='hello'

    assert "_validate 'name=hello'"
}

test_validate_should_support_value_containing_equals_sign() {
    __expected_value__='a=b'

    assert "_validate 'value=a=b' '.*'"
}

test_validate_fails_with_missing_argument() {
    assert_fails "_validate"
    assert_equals "_validate: some mandatory parameter is missing\n" "$(_validate 2>&1)"
}

test_validate_fails_with_too_many_arguments() {
    assert_fails "_validate 'a=b' 'c' 'd'"
    assert_equals "_validate: too many arguments (3)\n" "$(_validate 'a=b' 'c' 'd' 2>&1)"
}
