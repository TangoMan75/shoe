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

src_file="../../../src/shell/help/_help.sh"

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_alert_primary() { printf 'alert:%s\n' "$1"; }
_echo_error() { printf '%s' "$1"; }
_echo_info() { printf '%b' "$1"; }
_get_constants() { printf 'constant\n'; }
_get_flags() { printf 'flag\n'; }
_get_function_shoedoc() { printf '%s' "${__function_annotations__:-}"; }
_get_options() { printf 'option\n'; }
_get_padding() { printf '12'; }
_get_script_shoedoc() { printf 'annotations'; }
_get_shoedoc_description() { printf 'Description text'; }
_get_shoedoc_title() { printf 'Script title'; }
_print_command_details() { printf 'details:%s:%s:%s\n' "$1" "$2" "$3"; }
_print_commands() { printf 'commands:%s:%s\n' "$1" "$2"; }
_print_constants() { printf 'constants:%s:%s\n' "$1" "$2"; }
_print_description() { printf 'description:%s\n' "$1"; }
_print_flags() { printf 'flags:%s:%s\n' "$1" "$2"; }
_print_infos() { printf 'infos:%s\n' "$1"; }
_print_options() { printf 'options:%s:%s\n' "$1" "$2"; }
_print_usage() { printf 'usage:%s\n' "$1"; }

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------

test_help_should_print_full_script_help() {
    fixture="$(realpath '../../../tests/fixtures/fixture1.sh')"
    expected="alert:Script title
infos:${fixture}
description:Description text
usage:${fixture}
constants:${fixture}:12
flags:${fixture}:12
options:${fixture}:12
commands:${fixture}:12"

    assert_equals "${expected}" "$(_help "${fixture}")"
}

test_help_should_print_command_details_when_annotations_are_found() {
    fixture="$(realpath '../../../tests/fixtures/fixture1.sh')"
    __function_annotations__='## Some annotations'

    assert_equals \
        "alert:hello
details:${fixture}:hello:## Some annotations" \
        "$(_help "${fixture}" hello)"
}

test_help_should_print_nothing_for_unknown_command() {
    fixture="$(realpath '../../../tests/fixtures/fixture1.sh')"
    __function_annotations__=''

    assert_equals 'alert:unknown' "$(_help "${fixture}" unknown)"
}

test_help_fails_with_missing_argument() {
    assert_fails "_help"
    assert_equals "_help: some mandatory parameter is missing\n" "$(_help 2>&1)"
}

test_help_fails_with_nonexistent_file() {
    assert_fails "_help 'nonexistent.sh'"
}

test_help_fails_with_too_many_arguments() {
    assert_fails "_help 'a' 'b' 'c'"
    assert_equals "_help: too many arguments (3)\n" "$(_help 'a' 'b' 'c' 2>&1)"
}
