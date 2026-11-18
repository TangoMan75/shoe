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

src_file="../../../src/shell/symfony/_sf_test.sh"

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%b' "$1"; }
_echo_info() { :; }
php() { printf 'php %s\n' "$*"; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __stub_dir__="$(mktemp -d)"
}

teardown() {
    rm -rf "${__stub_dir__}"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "bash ${src_file}"
}

#--------------------------------------------------
# Symfony test
#--------------------------------------------------

test_sf_test_should_run_all_tests_without_file() {
    _phpunit() { printf 'phpunit'; }

    assert_equals 'php -d memory-limit=-1 phpunit --stop-on-failure' "$(_sf_test)"
}

test_sf_test_should_run_given_test_file() {
    _phpunit() { printf 'phpunit'; }
    __file__="${__stub_dir__}/Test.php"
    touch "${__file__}"

    assert_equals \
        "php -d memory-limit=-1 phpunit --stop-on-failure --testdox $(realpath "${__file__}")" \
        "$(_sf_test "${__file__}")"
}

test_sf_test_fails_with_nonexistent_file() {
    _phpunit() { printf 'phpunit'; }

    assert_fails "_sf_test 'nonexistent.php'"
}

test_sf_test_fails_with_too_many_arguments() {
    _phpunit() { printf 'phpunit'; }

    assert_fails "_sf_test 'a' 'b'"
    assert_equals '_sf_tests: too many arguments (2)' "$(_sf_test 'a' 'b' 2>&1)"
}
