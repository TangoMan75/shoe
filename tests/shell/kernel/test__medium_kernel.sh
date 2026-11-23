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

kernel_src="../../../src/shell/kernel/_medium_kernel.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%b' "$1"; }
_default() { printf 'default\n'; }
_help() { printf 'help:%s\n' "$2"; }
_validate() {
    printf 'validate:%s:%s\n' "$1" "$2"
    [ -z "${__invalid__:-}" ]
}
_before() { printf 'before\n'; }
_after() { printf 'after\n'; }
_check_duplicate_functions() { :; }
_get_flags() { printf '%s\n' "${__flags__:-}"; }
_get_options() { printf '%s\n' "${__options__:-}"; }
_get_functions_names() { printf '%s\n' ${__functions__:-greet}; }
_get_constraint() { printf '%s\n' "${__constraint__:-}"; }

greet() { printf 'greet:%s:%s\n' "$#" "$*"; }
first() { printf 'first\n'; }
failing() { return 2; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __kernel_copy__="$(mktemp)"
    sed '/^_medium_kernel "\$@"$/d' "${kernel_src}" > "${__kernel_copy__}"
    source "${__kernel_copy__}"
    __functions__='greet'
    __flags__=''
    __options__=''
    __constraint__=''
    __invalid__=''
    name=''
    verbose=''
}

teardown() {
    rm -f "${__kernel_copy__}"
}

#--------------------------------------------------
# Dispatch
#--------------------------------------------------

test_medium_kernel_should_dispatch_known_command() {
    assert_equals "before
greet:0:
after" "$(_medium_kernel 'greet')"
}

test_medium_kernel_should_call_default_without_argument() {
    assert_equals 'default' "$(_medium_kernel)"
}

test_medium_kernel_should_call_default_when_only_a_global_flag_is_given() {
    __flags__='verbose'

    assert_equals 'default' "$(_medium_kernel '--verbose')"
}

test_medium_kernel_should_reject_an_unknown_command() {
    assert_fails "_medium_kernel 'unknown'"
    assert_equals '"unknown" is not a valid command' \
        "$(_medium_kernel 'unknown' 2>&1)"
}

test_medium_kernel_should_reject_multiple_commands() {
    __functions__='greet first'

    assert_fails "_medium_kernel 'greet' 'first'"
    assert_equals 'only one command at a time' \
        "$(_medium_kernel 'greet' 'first' 2>&1)"
}

#--------------------------------------------------
# Unsupported command inputs
#--------------------------------------------------

test_medium_kernel_should_reject_positional_parameters() {
    assert_fails "_medium_kernel 'greet' 'World'"
    assert_equals '"World" is not a valid command' \
        "$(_medium_kernel 'greet' 'World' 2>&1)"
}

test_medium_kernel_should_reject_command_flags() {
    assert_fails "_medium_kernel 'greet' '--force'"
    assert_equals '"--force" is not a valid parameter' \
        "$(_medium_kernel 'greet' '--force' 2>&1)"
}

test_medium_kernel_should_reject_command_options() {
    assert_fails "_medium_kernel 'greet' '--name' 'World'"
    assert_equals '"--name" is not a valid parameter' \
        "$(_medium_kernel 'greet' '--name' 'World' 2>&1)"
}

#--------------------------------------------------
# Global flags
#--------------------------------------------------

test_medium_kernel_should_apply_a_global_flag_before_the_command() {
    __flags__='verbose'
    greet() { printf 'verbose:%s\n' "${verbose}"; }

    assert_equals "before
verbose:true
after" "$(_medium_kernel '--verbose' 'greet')"
}

test_medium_kernel_should_apply_a_global_flag_after_the_command() {
    __flags__='verbose'
    greet() { printf 'verbose:%s\n' "${verbose}"; }

    assert_equals "before
verbose:true
after" "$(_medium_kernel 'greet' '-v')"
}

#--------------------------------------------------
# Global options
#--------------------------------------------------

test_medium_kernel_should_apply_a_global_option_before_the_command() {
    __options__='name'
    __constraint__='/^[A-Za-z]+$/'
    greet() { printf 'name:%s\n' "${name}"; }

    assert_equals "validate:name=World:/^[A-Za-z]+$/
before
name:World
after" "$(_medium_kernel '--name' 'World' 'greet')"
}

test_medium_kernel_should_apply_a_global_option_after_the_command() {
    __options__='name'
    greet() { printf 'name:%s\n' "${name}"; }

    assert_equals "validate:name=World:
before
name:World
after" "$(_medium_kernel 'greet' '-n' 'World')"
}

test_medium_kernel_should_let_a_global_option_consume_a_command_name() {
    __options__='name'

    assert_equals "validate:name=greet:
default" "$(_medium_kernel '--name' 'greet')"
}

test_medium_kernel_should_require_a_value_for_a_global_option() {
    __options__='name'

    assert_fails "_medium_kernel 'greet' '--name'"
    assert_equals '"--name" requires value' \
        "$(_medium_kernel 'greet' '--name' 2>&1)"
}

test_medium_kernel_should_reject_an_invalid_global_option_value() {
    __options__='name'
    __constraint__='/^[a-z]+$/'
    __invalid__='true'

    assert_fails "_medium_kernel '--name' 'World' 'greet'"
    assert_equals 'validate:name=World:/^[a-z]+$/' \
        "$(_medium_kernel '--name' 'World' 'greet' 2>&1)"
}

#--------------------------------------------------
# Help
#--------------------------------------------------

test_medium_kernel_should_dispatch_help_without_a_target() {
    __functions__='help greet'

    assert_equals 'before
help:' "$(_medium_kernel 'help')"
}

test_medium_kernel_should_reject_a_help_target() {
    __functions__='help greet'

    assert_fails "_medium_kernel 'help' 'greet'"
    assert_equals 'only one command at a time' \
        "$(_medium_kernel 'help' 'greet' 2>&1)"
}

test_medium_kernel_should_reject_an_unknown_help_target() {
    __functions__='help greet'

    assert_fails "_medium_kernel 'help' 'bogus'"
    assert_equals '"bogus" is not a valid command' \
        "$(_medium_kernel 'help' 'bogus' 2>&1)"
}

test_medium_kernel_should_return_the_help_status() {
    __functions__='help greet'
    _help() { printf 'no documentation found\n'; return 1; }

    assert_fails "_medium_kernel 'help'"
}

#--------------------------------------------------
# Hooks
#--------------------------------------------------

test_medium_kernel_should_skip_the_after_hook_when_the_command_fails() {
    __functions__='failing'

    __status__=0
    __output__="$(_medium_kernel 'failing')" || __status__=$?

    assert_equals 2 "${__status__}"
    assert_equals 'before' "${__output__}"
}

#--------------------------------------------------
# Option terminator
#--------------------------------------------------

test_medium_kernel_should_stop_option_parsing_after_double_dash() {
    __flags__='verbose'
    greet() { printf 'verbose:%s\n' "${verbose:-}"; }

    assert_equals "before
verbose:
after" "$(_medium_kernel '--' 'greet')"

    assert_fails "_medium_kernel '--' 'greet' '--verbose'"
    assert_equals '"--verbose" is not a valid parameter' \
        "$(_medium_kernel '--' 'greet' '--verbose' 2>&1)"
}
