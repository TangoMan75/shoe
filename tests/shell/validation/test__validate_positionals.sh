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

src_file="../../../src/shell/validation/_validate_positionals.sh"

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%b' "$1"; }
_get_function_parameters() { printf '%s\n' "${__records__:-}"; }
_validate() { printf 'validate:%s:%s\n' "$1" "$2"; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

separator=$(printf '\037')

records_with_constraints="param${separator}WHO${separator}${separator}${separator}/^[A-Za-z-]+$/${separator}${separator}The recipient.
param${separator}COUNT${separator}${separator}${separator}${separator}1${separator}Repetition count."

records_without_constraints="param${separator}WHO${separator}${separator}${separator}${separator}${separator}The recipient.
param${separator}COUNT${separator}${separator}${separator}${separator}1${separator}Repetition count."

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------

test_validate_positionals_should_validate_a_matching_value() {
    __records__="${records_with_constraints}"

    assert_equals 'validate:WHO=World:/^[A-Za-z-]+$/' \
        "$(_validate_positionals 'script.sh' 'greet' 'World')"
}

test_validate_positionals_should_skip_a_parameter_without_constraint() {
    __records__="${records_without_constraints}"

    assert_equals '' \
        "$(_validate_positionals 'script.sh' 'greet' 'World' '42')"
}

test_validate_positionals_should_ignore_extra_values() {
    __records__="param${separator}WHO${separator}${separator}${separator}/^[A-Za-z-]+$/${separator}${separator}The recipient."

    assert_equals 'validate:WHO=World:/^[A-Za-z-]+$/' \
        "$(_validate_positionals 'script.sh' 'greet' 'World' 'extra')"
}

test_validate_positionals_should_return_success_without_values() {
    __records__="${records_with_constraints}"

    assert_equals '' "$(_validate_positionals 'script.sh' 'greet')"
}

test_validate_positionals_fails_with_missing_arguments() {
    assert_fails "_validate_positionals"
    assert_equals '_validate_positionals: some mandatory parameter is missing' \
        "$(_validate_positionals 2>&1)"
}

test_validate_positionals_fails_with_missing_function_name() {
    assert_fails "_validate_positionals 'script.sh'"
    assert_equals '_validate_positionals: some mandatory parameter is missing' \
        "$(_validate_positionals 'script.sh' 2>&1)"
}
