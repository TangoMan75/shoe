#!/bin/bash

#/*
# * This file is part of TangoMan Shoe package.
# *
# * Copyright (c) 2024 "Matthias Morin" <mat@tangoman.io>
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

src_file="../build/shoe-xl.sh"

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

test_hello_function_should_return_expected_string() {
    assert_equals "Hello, World !" "$(${src_file} hello)"
}

test_h_shorthand_should_return_expected_string() {
    assert_equals "Hello, World !" "$(${src_file} h)"
}

test_hello_function_should_return_given_parameter() {
    assert_equals "Hello, TangoMan !" "$(${src_file} hello --who TangoMan)"
}

test_h_shorthand_should_return_given_parameter() {
    assert_equals "Hello, TangoMan !" "$(${src_file} h --who TangoMan)"
}

test_hello_function_should_return_given_short_parameter() {
    assert_equals "Hello, TangoMan !" "$(${src_file} hello -w TangoMan)"
}

test_h_shorthand_should_return_given_short_parameter() {
    assert_equals "Hello, TangoMan !" "$(${src_file} h -w TangoMan)"
}

test_unknown_action_should_fail() {
    assert_fails "$(${src_file} foobar)"
}

test_unknown_flag_should_fail() {
    assert_fails "$(${src_file} -z)"
}

test_unknown_option_should_fail() {
    assert_fails "$(${src_file} --foobar "foobar")"
}

test_numeric_validation_should_fail() {
    assert_fails "$(${src_file} --count "foobar")"
}

test_alphabetic_validation_should_fail() {
    assert_fails "$(${src_file} --who "foobar123")"
}

