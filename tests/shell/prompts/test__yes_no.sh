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

src_file="../../../src/shell/prompts/_yes_no.sh"

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_success() { echo "$1" ; }
_echo_warning() { echo "$1" ; }

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------

test_yes_no_should_accept_yes_variations() {
    # Test various "yes" inputs
    echo 'y'   | assert '_yes_no'
    echo 'Y'   | assert '_yes_no'
    echo 'yes' | assert '_yes_no'
    echo 'yEs' | assert '_yes_no'
    echo 'YES' | assert '_yes_no'
    echo 'YeS' | assert '_yes_no'
    echo 'Yes' | assert '_yes_no'
}

test_yes_no_should_reject_non_yes_inputs() {
    # Test various non-"yes" inputs
    echo 'ye'    | assert_fails '_yes_no'
    echo 'yE'    | assert_fails '_yes_no'
    echo 'Ye'    | assert_fails '_yes_no'
    echo 'YE'    | assert_fails '_yes_no'
    echo 'n'     | assert_fails '_yes_no'
    echo 'N'     | assert_fails '_yes_no'
    echo 'no'    | assert_fails '_yes_no'
    echo 'NO'    | assert_fails '_yes_no'
    echo 'maybe' | assert_fails '_yes_no'
    echo ''      | assert_fails '_yes_no'
}

test_yes_no_should_use_default_question() {
    # Test that default question is used when no argument provided
    output=$(echo "y" | _yes_no 2>&1)
    assert "echo \"${output}\" | grep -q 'Confirm ? (yes/no):'"
}

test_yes_no_should_use_custom_question() {
    # Test that custom question is used when provided
    output=$(echo "y" | _yes_no "Are you sure?" 2>&1)
    assert "echo \"${output}\" | grep -q 'Are you sure? (yes/no):'"
}

