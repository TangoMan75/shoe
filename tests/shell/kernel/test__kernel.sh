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

kernel_src="../../../src/shell/kernel/_kernel.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%b' "$1"; }
_default() { printf 'default\n'; }
_help() { printf 'help:%s\n' "$2"; }
_validate() { printf 'validate:%s\n' "$1"; }
_before() { printf 'before\n'; }
_after() { printf 'after\n'; }
_get_flags() { printf '%s\n' "${__flags__:-}"; }
_get_options() { printf '%s\n' "${__options__:-}"; }
_get_functions_names() { printf '%s\n' ${__functions__:-hello}; }

hello() { printf 'hello:%s:%s\n' "${name:-}" "${verbose:-}"; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __kernel_copy__="$(mktemp)"
    sed '/^_kernel "\$@"$/d' "${kernel_src}" > "${__kernel_copy__}"
    source "${__kernel_copy__}"
    OPTIND=1
}

teardown() {
    rm -f "${__kernel_copy__}"
}

#--------------------------------------------------

test_kernel_should_dispatch_known_command() {
    __functions__='hello'

    assert_equals "before
hello::
after" "$(_kernel 'hello')"
}

test_kernel_should_dispatch_command_shorthand() {
    __functions__='hello'

    assert_equals "before
hello::
after" "$(_kernel 'h')"
}

test_kernel_should_call_default_when_no_argument_is_given() {
    assert_equals 'default' "$(_kernel)"
}

test_kernel_should_call_before_and_after_hooks() {
    __functions__='hello'

    assert_equals \
        "before
hello::
after" \
        "$(_kernel 'hello')"
}

test_kernel_should_parse_flags() {
    __functions__='hello'
    __flags__='verbose'

    assert_equals "before
hello::true
after" "$(_kernel '-v' 'hello')"
}

test_kernel_should_parse_options_with_values() {
    __functions__='hello'
    __options__='name'

    assert_equals \
        "validate:name=World
before
hello:World:
after" \
        "$(_kernel '-n' 'World' 'hello')"
}

test_kernel_should_parse_long_options() {
    __functions__='hello'
    __options__='name'

    assert_equals \
        "validate:name=World
before
hello:World:
after" \
        "$(_kernel '--name' 'World' 'hello')"
}

test_kernel_should_fail_when_option_requires_value() {
    __functions__='hello'
    __options__='name'

    assert_fails "_kernel '-n'"
    assert_equals '"--name" requires value' "$(_kernel '-n' 2>&1)"
}

test_kernel_should_dispatch_help_command() {
    __functions__='help hello'

    assert_equals "before
help:hello" "$(_kernel 'help' 'hello')"
}

test_kernel_should_fail_with_unknown_command() {
    __functions__='hello'

    assert_fails "_kernel 'unknown'"
    assert_equals '"unknown" is not a valid command' "$(_kernel 'unknown' 2>&1)"
}

test_kernel_should_fail_with_unknown_parameter() {
    __functions__='hello'

    assert_fails "_kernel '-z'"
    assert_equals '"-z" is not a valid parameter' "$(_kernel '-z' 2>&1)"
}

test_kernel_should_fail_when_function_is_defined_multiple_times() {
    __functions__='hello hello'

    assert_fails "_kernel 'hello'"
    assert_equals 'function "hello" is defined multiple times' "$(_kernel 'hello' 2>&1)"
}

test_kernel_should_have_valid_syntax() {
    assert "bash -n '${kernel_src}'"
}

test_large_kernel_should_have_valid_syntax() {
    assert "bash -n '../../../src/shell/kernel/_large_kernel.sh'"
}

test_light_kernel_should_have_valid_syntax() {
    assert "bash -n '../../../src/shell/kernel/_light_kernel.sh'"
}
