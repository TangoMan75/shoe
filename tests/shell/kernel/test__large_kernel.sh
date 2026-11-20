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

kernel_src="../../../src/shell/kernel/_large_kernel.sh"

source "../../../src/shell/validation/_validate_positionals.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%b' "$1"; }
_default() { printf 'default\n'; }
_help() { printf 'help:%s\n' "$2"; }
_validate() { printf 'validate:%s:%s\n' "$1" "$2"; }
_before() { printf 'before\n'; }
_after() { printf 'after\n'; }
_check_duplicate_functions() { :; }
_get_flags() { printf '%s\n' "${__flags__:-}"; }
_get_options() { printf '%s\n' "${__options__:-}"; }
_get_functions_names() { printf '%s\n' ${__functions__:-greet}; }
_get_function_parameters() { printf '%s\n' "${__records__:-}"; }
_get_constraint() { printf '%s\n' "${__constraint__:-}"; }

greet() { printf 'greet:%s:%s\n' "${1:-}" "${2:-}"; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

separator=$(printf '\037')

setup() {
    __kernel_copy__="$(mktemp)"
    sed '/^_large_kernel "\$@"$/d' "${kernel_src}" > "${__kernel_copy__}"
    source "${__kernel_copy__}"
}

teardown() {
    rm -f "${__kernel_copy__}"
}

#--------------------------------------------------

test_large_kernel_should_dispatch_known_command() {
    __functions__='greet'

    assert_equals "before
greet::
after" "$(_large_kernel 'greet')"
}

test_large_kernel_should_pass_positional_parameters_to_the_command() {
    __functions__='greet'

    assert_equals "before
greet:World:42
after" "$(_large_kernel 'greet' 'World' '42')"
}

test_large_kernel_should_parse_command_options_before_the_command() {
    __functions__='greet'
    __records__="option${separator}name${separator}n${separator}name${separator}${separator}${separator}Name"

    assert_equals "validate:name=World:
before
greet::
after" "$(_large_kernel '--name' 'World' 'greet')"
}

test_large_kernel_should_parse_command_options_after_the_command() {
    __functions__='greet'
    __records__="option${separator}name${separator}n${separator}name${separator}${separator}${separator}Name"

    assert_equals "validate:name=World:
before
greet::
after" "$(_large_kernel 'greet' '--name' 'World')"
}

test_large_kernel_should_validate_positional_parameters() {
    __functions__='greet'
    __records__="param${separator}WHO${separator}${separator}${separator}/^[A-Za-z-]+$/${separator}${separator}The recipient."

    assert_equals "before
validate:WHO=World:/^[A-Za-z-]+$/
greet:World:
after" "$(_large_kernel 'greet' 'World')"
}

test_large_kernel_should_reject_a_positional_before_any_command() {
    __functions__='greet'

    assert_fails "_large_kernel 'World'"
    assert_equals '"World" is not a valid command' "$(_large_kernel 'World' 2>&1)"
}

test_large_kernel_should_dispatch_help_before_the_command() {
    __functions__='help greet'

    assert_equals 'before
help:greet' "$(_large_kernel 'help' 'greet')"
}

test_large_kernel_should_have_valid_syntax() {
    assert "bash -n '${kernel_src}'"
}
