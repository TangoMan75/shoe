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
_echo_error() { printf 'error: %b' "$1" >&2; }

greet() { printf 'greet:%s:%s\n' "${1:-}" "${2:-}"; }
hello() { printf 'hello\n'; }
help() { _help "$0" "$1"; }

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

test_light_kernel_should_dispatch_known_command() {
    __functions__='greet'

    assert_equals "before
greet::
after" "$(_light_kernel 'greet')"
}

test_light_kernel_should_reject_multiple_commands() {
    __functions__='greet hello'

    assert_fails "_light_kernel 'greet' 'hello'"
    assert_equals 'error: No positional parameter, option or flag is supported, and only one command may run at a time' \
        "$(_light_kernel 'greet' 'hello' 2>&1)"
}

test_light_kernel_should_reject_positional_parameters() {
    __functions__='greet'

    assert_fails "_light_kernel 'greet' 'World'"
    assert_equals 'error: No positional parameter, option or flag is supported, and only one command may run at a time' \
        "$(_light_kernel 'greet' 'World' 2>&1)"
}

test_light_kernel_should_reject_an_unknown_command() {
    __functions__='greet'

    assert_fails "_light_kernel 'unknown'"
    assert_equals 'error: "unknown" is not a valid command' \
        "$(_light_kernel 'unknown' 2>&1)"
}

test_light_kernel_should_dispatch_help_command() {
    __functions__='help greet'

    assert_equals "before
help:
after" "$(_light_kernel 'help')"
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

test_light_kernel_should_skip_the_after_hook_when_the_command_fails() {
    __functions__='failing'
    failing() { return 2; }

    __status__=0
    __output__="$(_light_kernel 'failing')" || __status__=$?

    assert_equals 2 "${__status__}"
    assert_equals 'before' "${__output__}"
}
