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

src_file="../../../src/shell/help/_print_command_details.sh"

source "${src_file}"
source "../../../src/shell/shoedoc/_get_shoedoc_description.sh"
source "../../../src/shell/shoedoc/_get_shoedoc_tag.sh"
source "../../../src/shell/shoedoc/_get_shoedoc_title.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%s' "$1"; }
_echo_primary() { printf '%*s' "${2:-0}" ''; printf '%b' "$1"; }
_echo_warning() { printf '%b' "$1"; }
_get_flags() { printf 'verbose\n'; }
_get_options() { printf 'store\n'; }
_get_padding() { printf '10\n'; }
_print_description() { printf 'Description:\n  %s\n\n' "$1"; }
_print_flags() { printf 'Flags:\n  --verbose Print additional details\n\n'; }
_print_options() { printf 'Options:\n  --store Bookmark store file (default: store.tsv)\n\n'; }
_print_usage() { printf 'Usage:\n  sh script.sh <command>\n\n'; }

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------

fixture='## Greet someone
##
## Prints a greeting.
##
## @namespace src/shell/hello
## @requires echo
## @param {str} <WHO> (default:"World") The recipient name.
## @example hello
## @example hello World
## @assumes who
## @stdin the recipient name
## @stdout the greeting lines'

expected='Greet someone

Description:
  Prints a greeting.

Usage:
  sh script.sh <command>

Examples:
  hello
hello World

Assumes:
  who

Stdin:
  the recipient name

Stdout:
  the greeting lines

Flags:
  --verbose Print additional details

Options:
  --store Bookmark store file (default: store.tsv)'

script_path='../../../tests/fixtures/fixture1.sh'

test_should_print_command_details() {
    assert_equals "${expected}" "$(_print_command_details "${script_path}" hello "${fixture}")"
}

test_should_omit_empty_sections() {
    _print_flags() { :; }
    _print_options() { :; }

    minimal_fixture='## Greet someone
##
## Prints a greeting.'

    expected='Greet someone

Description:
  Prints a greeting.

Usage:
  sh script.sh <command>'

    assert_equals "${expected}" "$(_print_command_details "${script_path}" hello "${minimal_fixture}")"
}

#--------------------------------------------------

test_should_fail_with_missing_arguments() {
    assert_fails "$(_print_command_details)"
    assert_equals "_print_command_details: some mandatory parameter is missing\n" "$(_print_command_details)"
}

test_should_fail_with_missing_command_name() {
    assert_fails "$(_print_command_details "${script_path}")"
    assert_equals "_print_command_details: some mandatory parameter is missing\n" "$(_print_command_details "${script_path}")"
}

test_should_fail_with_missing_annotations() {
    assert_fails "$(_print_command_details "${script_path}" hello)"
    assert_equals "_print_command_details: some mandatory parameter is missing\n" "$(_print_command_details "${script_path}" hello)"
}

test_should_fail_with_nonexistent_file() {
    assert_fails "$(_print_command_details 'nonexistent.sh' hello "${fixture}")"
}

test_should_fail_with_too_many_arguments() {
    assert_fails "$(_print_command_details "${script_path}" hello "${fixture}" extra)"
    assert_equals "_print_command_details: too many arguments (4)\n" "$(_print_command_details "${script_path}" hello "${fixture}" extra)"
}

