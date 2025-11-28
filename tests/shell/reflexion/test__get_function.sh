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

# https://github.com/pgrange/bash_unit
#
#     assert "test -e /tmp/the_file"
#     assert_fails "grep this /tmp/the_file" "should not write 'this' in /tmp/the_file"
#     assert_status_code 25 code # 127: command not found; 126: command not executable
#     assert_equals "a string" "another string" "a string should be another string"
#     assert_not_equals "a string" "a string" "a string should be different from another string"
#     fake ps echo hello world

src_file="../../../src/shell/reflexion/_get_function.sh"

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { echo "$1" ; }

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------

test_get_function_returns_function_with_annotations() {
    actual="$(_get_function "../../../tests/fixtures/reflexion_test.sh" "public_function")"
    expected=$'## Public function\n##\n## {\n##   "namespace": "test",\n##   "summary": "A test function.",\n##   "parameters": [\n##     {\n##       "position": 1,\n##       "name": "ARG",\n##       "type": "str",\n##       "description": "An argument.",\n##       "nullable": false\n##     }\n##   ]\n## }\npublic_function() {\n    echo "public $1"'
    assert_equals "${expected}" "${actual}"
}

test_get_function_returns_empty_for_nonexistent_function() {
    actual="$(_get_function "../../../tests/fixtures/reflexion_test.sh" "nonexistent")"
    assert_equals "" "${actual}"
}

test_get_function_fails_with_missing_arguments() {
    assert_fails "$(_get_function)"
    assert_equals "_get_function: some mandatory parameter is missing\n" "$(_get_function)"
}

test_get_function_fails_with_missing_function_name() {
    assert_fails "$(_get_function ../../../tests/fixtures/reflexion_test.sh)"
    assert_equals "_get_function: some mandatory parameter is missing\n" "$(_get_function ../../../tests/fixtures/reflexion_test.sh)"
}

test_get_function_fails_with_nonexistent_file() {
    assert_fails "$(_get_function nonexistent.sh public_function)"
}

