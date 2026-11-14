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

src_file="../../build/hello.sh"

source ../helper/_remove_colors.sh

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------
# Commands
#--------------------------------------------------

test_unknown_command_should_fail() {
    assert_fails "$(${src_file} tango)"
}

test_unknown_command_should_fail_with_expected_error_message() {
    assert_equals "error: \"tango\" is not a valid command" "$(_remove_colors "$(${src_file} tango 2>&1)")"
}

test_hello_command_should_return_expected_string() {
    assert_equals "Hello, World !" "$(${src_file} hello)"
}

test_hello_command_should_return_given_option() {
    assert_equals "Hello, TangoMan !" "$(${src_file} hello --who TangoMan)"
}

test_hello_command_should_return_given_short_option() {
    assert_equals "Hello, TangoMan !" "$(${src_file} hello -w TangoMan)"
}

#--------------------------------------------------
# Shorthands
#--------------------------------------------------

test_unknown_shorthand_should_fail() {
    assert_fails "$(${src_file} z)"
}

test_unknown_shorthand_should_fail_with_expected_error_message() {
    assert_equals "error: \"z\" is not a valid command" "$(_remove_colors "$(${src_file} z 2>&1)")"
}

test_h_shorthand_should_return_expected_string() {
    assert_equals "Hello, World !" "$(${src_file} h)"
}

test_h_shorthand_should_return_given_option() {
    assert_equals "Hello, TangoMan !" "$(${src_file} h --who TangoMan)"
}

test_h_shorthand_should_return_given_short_option() {
    assert_equals "Hello, TangoMan !" "$(${src_file} h -w TangoMan)"
}

#--------------------------------------------------
# Flags
#--------------------------------------------------

test_unknown_flag_should_fail() {
    assert_fails "$(${src_file} --tango)"
}

test_unknown_flag_should_fail_with_expected_error_message() {
    assert_equals "error: \"--tango\" is not a valid parameter" "$(_remove_colors "$(${src_file} --tango 2>&1)")"
}

test_prefix_flag_should_be_off_by_default() {
    assert_equals "Hello, World !" "$(${src_file} hello)"
}

test_prefix_flag_should_prefix_output() {
    assert_equals "1: Hello, World !" "$(${src_file} hello --prefix)"
}

test_prefix_flag_should_accept_short_alias() {
    assert_equals "1: Hello, World !" "$(${src_file} hello -p)"
}

#--------------------------------------------------
# Short Flags
#--------------------------------------------------

test_unknown_short_flag_should_fail() {
    assert_fails "$(${src_file} -t)"
}

test_unknown_short_flag_should_fail_with_expected_error_message() {
    assert_equals "error: \"-t\" is not a valid parameter" "$(_remove_colors "$(${src_file} -t 2>&1)")"
}

test_verbose_flag_should_accept_short_alias() {
    assert_equals "verbose: Hello World 1 time(s), ending \"!\"
Hello, World !" "$(${src_file} hello -v 2>&1)"
}

#--------------------------------------------------
# Options
#--------------------------------------------------

test_unknown_option_should_fail() {
    assert_fails "$(${src_file} --tango "tango")"
}

test_unknown_option_should_fail_with_expected_error_message() {
    assert_equals "error: \"--tango\" is not a valid parameter" "$(_remove_colors "$(${src_file} --tango "tango"  2>&1)")"
}

#--------------------------------------------------
# Short Options
#--------------------------------------------------

test_unknown_short_option_should_fail() {
    assert_fails "$(${src_file} -t "tango")"
}

test_unknown_short_option_should_fail_with_expected_error_message() {
    assert_equals "error: \"-t\" is not a valid parameter" "$(_remove_colors "$(${src_file} -t "tango"  2>&1)")"
}

#--------------------------------------------------
# Validation
#--------------------------------------------------

test_option_should_fail_alphabetical_validation() {
    assert_fails "$(${src_file} --who 123)"
}

test_option_should_fail_alphabetical_validation_with_expected_error_message() {
    assert_equals "error: invalid \"who\", expected \"/^[a-zA-Z -]+$/\", \"123\" given" "$(_remove_colors "$(${src_file} --who 123 2>&1)")"
}

test_option_should_fail_numeric_validation() {
    assert_fails "$(${src_file} --count abc)"
}

test_option_should_fail_numeric_validation_with_expected_error_message() {
    assert_equals "error: invalid \"count\", expected \"/^[1-9][0-9]?$/\", \"abc\" given" "$(_remove_colors "$(${src_file} --count abc 2>&1)")"
}

#--------------------------------------------------
# Short Validation
#--------------------------------------------------

test_short_option_should_fail_alphabetical_validation() {
    assert_fails "$(${src_file} --w 123)"
}

test_short_option_should_fail_alphabetical_validation_with_expected_error_message() {
    assert_equals "error: invalid \"who\", expected \"/^[a-zA-Z -]+$/\", \"123\" given" "$(_remove_colors "$(${src_file} -w 123 2>&1)")"
}

test_short_option_should_fail_numeric_validation() {
    assert_fails "$(${src_file} -c abc)"
}

test_short_option_should_fail_numeric_validation_with_expected_error_message() {
    assert_equals "error: invalid \"count\", expected \"/^[1-9][0-9]?$/\", \"abc\" given" "$(_remove_colors "$(${src_file} -c abc 2>&1)")"
}

