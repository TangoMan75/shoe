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
_get_function_parameters() {
    case "${2:-}" in
        first) printf '%s\n' "${__first_records__:-}" ;;
        second) printf '%s\n' "${__second_records__:-}" ;;
        *) printf '%s\n' "${__records__:-}" ;;
    esac
}
_get_constraint() { printf '%s\n' "${__constraint__:-}"; }

greet() { printf 'greet:%s:%s\n' "${who:-}" "${count:-}"; }
first() { printf 'first:%s:%s\n' "${name:-}" "${force:-}"; }
second() { printf 'second:%s:%s\n' "${name:-}" "${force:-}"; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

separator=$(printf '\037')

setup() {
    __kernel_copy__="$(mktemp)"
    sed '/^_kernel "\$@"$/d' "${kernel_src}" > "${__kernel_copy__}"
    source "${__kernel_copy__}"
    __records__=''
    __first_records__=''
    __second_records__=''
    who=''
    count=''
    name=''
    force=''
}

teardown() {
    rm -f "${__kernel_copy__}"
}

#--------------------------------------------------

test_kernel_should_dispatch_known_command() {
    __functions__='greet'

    assert_equals "before
greet::
after" "$(_kernel 'greet')"
}

test_kernel_should_bind_positional_parameters_to_the_command() {
    __functions__='greet'
    __records__="param${separator}who${separator}${separator}${separator}${separator}${separator}The recipient.
param${separator}count${separator}${separator}${separator}${separator}${separator}The count."

    assert_equals "before
greet:World:42
after" "$(_kernel 'greet' 'World' '42')"
}

test_kernel_should_preserve_empty_positional_parameters() {
    __functions__='greet'
    __records__="param${separator}who${separator}${separator}${separator}${separator}${separator}The recipient.
param${separator}count${separator}${separator}${separator}${separator}${separator}The count."

    assert_equals "before
greet::42
after" "$(_kernel 'greet' '' '42')"
}

test_kernel_should_apply_parameter_defaults() {
    __functions__='greet'
    __records__="param${separator}who${separator}${separator}${separator}${separator}\"World\"${separator}The recipient.
param${separator}count${separator}${separator}${separator}${separator}1${separator}The count."

    assert_equals "before
greet:World:1
after" "$(_kernel 'greet')"
}

test_kernel_should_call_the_command_without_positional_parameters() {
    __functions__='count_arguments'
    count_arguments() { printf 'arguments:%s\n' "$#"; }

    assert_equals "before
arguments:0
after" "$(_kernel 'count_arguments' 'World' '42')"
}

test_kernel_should_parse_command_options_before_the_command() {
    __functions__='greet'
    __records__="option${separator}name${separator}n${separator}name${separator}${separator}${separator}Name"

    assert_equals "before
validate:name=World:
greet::
after" "$(_kernel '--name' 'World' 'greet')"
}

test_kernel_should_parse_command_options_after_the_command() {
    __functions__='greet'
    __records__="option${separator}name${separator}n${separator}name${separator}${separator}${separator}Name"

    assert_equals "before
validate:name=World:
greet::
after" "$(_kernel 'greet' '--name' 'World')"
}

test_kernel_should_bind_command_options() {
    __functions__='first'
    __first_records__="option${separator}name${separator}n${separator}name${separator}${separator}\"one\"${separator}Name"

    assert_equals "before
first:one:
after" "$(_kernel 'first')"

    assert_equals "before
validate:name=left:
first:left:
after" "$(_kernel 'first' '--name' 'left')"
}

test_kernel_should_not_split_control_characters_in_arguments() {
    __functions__='first'
    __first_records__="option${separator}name${separator}n${separator}name${separator}${separator}${separator}Name
flag${separator}force${separator}f${separator}force${separator}${separator}${separator}Force"

    assert_equals "before
validate:name=left${separator}--force:
first:left${separator}--force:false
after" "$(_kernel 'first' '--name' "left${separator}--force")"
}

test_kernel_should_bind_command_flags() {
    __functions__='first'
    __first_records__="flag${separator}force${separator}f${separator}force${separator}${separator}${separator}Force"

    assert_equals "before
first::false
after" "$(_kernel 'first')"

    assert_equals "before
first::true
after" "$(_kernel '--force' 'first')"

    assert_equals "before
first::true
after" "$(_kernel 'first' '--force')"
}

test_kernel_should_attach_leading_options_to_the_command() {
    __functions__='first'
    __first_records__="option${separator}name${separator}n${separator}name${separator}${separator}\"one\"${separator}Name"

    assert_equals "before
validate:name=left:
first:left:
after" "$(_kernel '--name' 'left' 'first')"
}

test_kernel_should_reject_multiple_commands() {
    __functions__='first second'
    __first_records__="option${separator}name${separator}n${separator}name${separator}${separator}\"one\"${separator}Name"
    __second_records__="option${separator}name${separator}n${separator}name${separator}${separator}\"two\"${separator}Name"

    assert_fails "_kernel 'first' 'second'"
    assert_equals 'only one command at a time' \
        "$(_kernel 'first' 'second' 2>&1)"
}

test_kernel_should_reject_a_command_option_for_another_command() {
    __functions__='first second'
    __first_records__="option${separator}name${separator}n${separator}name${separator}${separator}\"one\"${separator}Name"

    assert_fails "_kernel 'second' '--name' 'left'"
    assert_equals "before
\"--name\" is not a valid parameter" \
        "$(_kernel 'second' '--name' 'left' 2>&1)"
}

test_kernel_should_validate_positional_parameters() {
    __functions__='greet'
    __records__="param${separator}who${separator}${separator}${separator}/^[A-Za-z-]+$/${separator}${separator}The recipient."

    assert_equals "before
validate:who=World:/^[A-Za-z-]+$/
greet:World:
after" "$(_kernel 'greet' 'World')"
}

test_kernel_should_reject_a_positional_before_any_command() {
    __functions__='greet'

    assert_fails "_kernel 'World'"
    assert_equals '"World" is not a valid command' "$(_kernel 'World' 2>&1)"
}

test_kernel_should_dispatch_help_before_the_command() {
    __functions__='help greet'

    assert_equals 'before
help:greet' "$(_kernel 'help' 'greet')"
}

test_kernel_should_pass_an_unknown_help_target_to_help() {
    __functions__='help greet'

    assert_equals 'before
help:bogus' "$(_kernel 'help' 'bogus')"
}

test_kernel_should_return_the_help_status() {
    __functions__='help greet'
    _help() { printf 'no documentation found for "%s"\n' "$2"; return 1; }

    assert_fails "_kernel 'help' 'bogus'"
}

test_kernel_should_skip_the_after_hook_when_binding_fails() {
    __functions__='greet'
    _validate_positionals() { return 1; }

    assert_fails "_kernel 'greet'"
    assert_equals 'before' "$(_kernel 'greet')"
}

test_kernel_should_skip_the_after_hook_when_the_command_fails() {
    __functions__='failing'
    failing() { return 2; }

    __status__=0
    __output__="$(_kernel 'failing')" || __status__=$?

    assert_equals 2 "${__status__}"
    assert_equals 'before' "${__output__}"
}

test_kernel_should_stop_option_parsing_after_double_dash() {
    __functions__='greet'
    __records__="param${separator}who${separator}${separator}${separator}${separator}${separator}The recipient."

    assert_equals "before
greet:--force:
after" "$(_kernel 'greet' '--' '--force')"
}

test_kernel_should_bind_global_flags_and_options() {
    __functions__='global_view'
    __flags__='verbose'
    __options__='store'
    global_view() { printf 'verbose:%s store:%s\n' "${verbose}" "${store}"; }

    assert_equals "validate:store=left:
before
verbose:true store:left
after" "$(_kernel '-v' '--store' 'left' 'global_view')"
}

test_kernel_should_reject_an_ambiguous_global_flag() {
    __functions__='greet'
    __flags__='verbose'
    __records__="flag${separator}verbose${separator}v${separator}verbose${separator}${separator}${separator}Verbose"

    assert_fails "_kernel '-v' 'greet'"
    assert_equals '"-v" is ambiguous: declared both globally and by a command' \
        "$(_kernel '-v' 'greet' 2>&1)"
}

test_kernel_should_reject_an_ambiguous_global_option() {
    __functions__='greet'
    __options__='output'
    __records__="option${separator}output${separator}o${separator}output${separator}${separator}${separator}Output"

    assert_fails "_kernel 'greet' '-o' 'left'"
    assert_equals '"-o" is ambiguous: declared both globally and by a command' \
        "$(_kernel 'greet' '-o' 'left' 2>&1)"
}
