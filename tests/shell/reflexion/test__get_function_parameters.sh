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

src_file="../../../src/shell/reflexion/_get_function_parameters.sh"

source "${src_file}"
source "../../../src/shell/shoedoc/_get_function_shoedoc.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { echo "$1" ; }

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------

expected=$'option\037name\037n\037name\037/^[A-Za-z0-9._-]+$/\037""\037Display name\noption\037count\037c\037count\037\0371\037Repetition count\noption\037input\037i\037\037\037\037Path to input\nflag\037force\037f\037force\037\037\037Force the operation\nflag\037verbose\037\037\037\037\037Verbose output'

test_get_function_parameters_returns_expected_records() {
    actual="$(_get_function_parameters "../../../tests/fixtures/function_parameters.sh" scoped_add)"
    assert_equals "${expected}" "${actual}"
}

test_get_function_parameters_returns_empty_for_function_without_parameters() {
    actual="$(_get_function_parameters "../../../tests/fixtures/function_parameters.sh" scoped_plain)"
    assert_equals "" "${actual}"
}

test_get_function_parameters_fails_with_missing_arguments() {
    assert_fails "$(_get_function_parameters)"
    assert_equals "_get_function_parameters: some mandatory parameter is missing\n" "$(_get_function_parameters)"
}

test_get_function_parameters_fails_with_missing_function_name() {
    assert_fails "$(_get_function_parameters ../../../tests/fixtures/function_parameters.sh)"
    assert_equals "_get_function_parameters: some mandatory parameter is missing\n" "$(_get_function_parameters ../../../tests/fixtures/function_parameters.sh)"
}

test_get_function_parameters_fails_with_nonexistent_file() {
    assert_fails "$(_get_function_parameters nonexistent.sh scoped_add)"
}

test_get_function_parameters_fails_with_too_many_arguments() {
    assert_fails "$(_get_function_parameters ../../../tests/fixtures/function_parameters.sh scoped_add extra)"
    assert_equals "_get_function_parameters: too many arguments (3)\n" "$(_get_function_parameters ../../../tests/fixtures/function_parameters.sh scoped_add extra)"
}
