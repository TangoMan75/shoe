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

kernel_src="../../../src/shell/kernel/_light_kernel.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_default() { printf 'default\n'; }
_help() { printf 'help:%s\n' "$2"; }
_before() { printf 'before\n'; }
_after() { printf 'after\n'; }
_check_duplicate_functions() { :; }
_get_functions_names() { printf '%s\n' ${__functions__:-greet}; }

greet() { printf 'greet:%s:%s\n' "${1:-}" "${2:-}"; }

_DANGER=''
_EOL=''

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __kernel_copy__="$(mktemp)"
    sed '/^_light_kernel "\$@"$/d' "${kernel_src}" > "${__kernel_copy__}"
    source "${__kernel_copy__}"
}

teardown() {
    rm -f "${__kernel_copy__}"
}

#--------------------------------------------------

test_light_kernel_should_have_valid_syntax() {
    assert "bash -n '${kernel_src}'"
}

#--------------------------------------------------

test_light_kernel_should_dispatch_known_command() {
    __functions__='greet'

    assert_equals "before
greet::
after" "$(_light_kernel 'greet')"
}

test_light_kernel_should_pass_positional_parameters_to_the_command() {
    __functions__='greet'

    assert_equals "before
greet:World:42
after" "$(_light_kernel 'greet' 'World' '42')"
}

test_light_kernel_should_reject_a_positional_before_any_command() {
    __functions__='greet'

    assert_fails "_light_kernel 'World'"
    assert_equals 'error: "World" is not a valid command' "$(_light_kernel 'World' 2>&1)"
}

test_light_kernel_should_dispatch_help_before_the_command() {
    __functions__='help greet'

    assert_equals 'before
help:greet' "$(_light_kernel 'help' 'greet')"
}

test_light_kernel_should_call_default_when_no_argument_is_given() {
    assert_equals 'default' "$(_light_kernel)"
}

test_light_kernel_should_call_before_and_after_hooks() {
    __functions__='greet'

    assert_equals "before
greet::
after" "$(_light_kernel 'greet')"
}
