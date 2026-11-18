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

src_file="../../../src/shell/validation/_check_duplicate_functions.sh"

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%s' "$1"; }
_get_functions_names() {
    printf '%s' "$2" > "${__arguments_file__}"
    printf '%s\n' ${__functions__:-}
}

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __arguments_file__="$(mktemp)"
}

teardown() {
    rm -f "${__arguments_file__}"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------

test_check_duplicate_functions_passes_with_unique_names() {
    __functions__='hello goodbye'

    assert "_check_duplicate_functions 'script.sh'"
}

test_check_duplicate_functions_fails_with_duplicated_name() {
    __functions__='hello goodbye hello'

    assert_fails "_check_duplicate_functions 'script.sh'"
    assert_equals \
        "function \"hello\" is defined multiple times\n" \
        "$(_check_duplicate_functions 'script.sh' 2>&1)"
}

test_check_duplicate_functions_reads_private_functions() {
    __functions__='_hello'

    _check_duplicate_functions 'script.sh'

    assert_equals 'true' "$(cat "${__arguments_file__}")"
}

test_check_duplicate_functions_fails_with_missing_argument() {
    assert_fails "$(_check_duplicate_functions)"
    assert_equals "_check_duplicate_functions: some mandatory parameter is missing\n" "$(_check_duplicate_functions)"
}

test_check_duplicate_functions_fails_with_too_many_arguments() {
    assert_fails "$(_check_duplicate_functions 'script.sh' 'extra')"
    assert_equals "_check_duplicate_functions: too many arguments (2)\n" "$(_check_duplicate_functions 'script.sh' 'extra')"
}
