#!/bin/bash

#/*
# * This file is part of TangoMan Shoe package.
# *
# * Copyright (c) 2025 "Matthias Morin" <mat@tangoman.io>
# *
# * This source file is subject to the MIT license that is bundled
# * with this source code in the file LICENSE.
# */

# https://github.com/pgrange/bash_unit
#
#     assert "test -e /tmp/the_file"
#     assert_fails "grep this /tmp/the_file" "should not write 'this' in /tmp/the_file"
#     assert_status_code 25 code # 127: command not found; 126: command not executable
#     assert_equals "a string" "another string" "a string should be another string"
#     assert_not_equals "a string" "a string" "a string should be different from another string"
#     fake ps echo hello world

src_file="../build/shoe.sh"

source ./_remove_colors.sh

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
    assert_equals "error: \"tango\" is not a valid command" "$(_remove_colors "$(${src_file} tango)")"
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
    assert_equals "error: \"z\" is not a valid command" "$(_remove_colors "$(${src_file} z)")"
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
    assert_equals "error: \"--tango\" is not a valid parameter" "$(_remove_colors "$(${src_file} --tango)")"
}

test_flag_test_command_should_return_given_flag() {
    assert_equals "Flag is off" "$(${src_file} flag_test)"
}

test_flag_test_command_should_return_given_flag() {
    assert_equals "Flag is on" "$(${src_file} flag_test --flag)"
}

#--------------------------------------------------
# Short Flags
#--------------------------------------------------

test_unknown_short_flag_should_fail() {
    assert_fails "$(${src_file} -t)"
}

test_unknown_short_flag_should_fail_with_expected_error_message() {
    assert_equals "error: \"-t\" is not a valid parameter" "$(_remove_colors "$(${src_file} -t)")"
}

test_flag_test_command_should_return_given_short_flag() {
    assert_equals "Flag is on" "$(${src_file} flag_test -f)"
}

#--------------------------------------------------
# Options
#--------------------------------------------------

test_unknown_option_should_fail() {
    assert_fails "$(${src_file} --tango "tango")"
}

test_unknown_option_should_fail_with_expected_error_message() {
    assert_equals "error: \"--tango\" is not a valid parameter" "$(_remove_colors "$(${src_file} --tango "tango")")"
}

#--------------------------------------------------
# Short Options
#--------------------------------------------------

test_unknown_short_option_should_fail() {
    assert_fails "$(${src_file} -t "tango")"
}

test_unknown_short_option_should_fail_with_expected_error_message() {
    assert_equals "error: \"-t\" is not a valid parameter" "$(_remove_colors "$(${src_file} -t "tango")")"
}

#--------------------------------------------------
# Validation
#--------------------------------------------------

test_option_should_fail_alphabetical_validation() {
    assert_fails "$(${src_file} --who 123)"
}

test_option_should_fail_alphabetical_validation_with_expected_error_message() {
    assert_equals "error: invalid \"who\", expected \"/^[a-zA-Z-]+$/\", \"123\" given" "$(_remove_colors "$(${src_file} --who 123)")"
}

test_option_should_fail_numeric_validation() {
    assert_fails "$(${src_file} --count abc)"
}

test_option_should_fail_numeric_validation_with_expected_error_message() {
    assert_equals "error: invalid \"count\", expected \"/[1-9]/\", \"abc\" given" "$(_remove_colors "$(${src_file} --count abc)")"
}

#--------------------------------------------------
# Short Validation
#--------------------------------------------------

test_short_option_should_fail_alphabetical_validation() {
    assert_fails "$(${src_file} --w 123)"
}

test_short_option_should_fail_alphabetical_validation_with_expected_error_message() {
    assert_equals "error: invalid \"who\", expected \"/^[a-zA-Z-]+$/\", \"123\" given" "$(_remove_colors "$(${src_file} -w 123)")"
}

test_short_option_should_fail_numeric_validation() {
    assert_fails "$(${src_file} -c abc)"
}

test_short_option_should_fail_numeric_validation_with_expected_error_message() {
    assert_equals "error: invalid \"count\", expected \"/[1-9]/\", \"abc\" given" "$(_remove_colors "$(${src_file} -c abc)")"
}

