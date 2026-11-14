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

src_file="../../../src/shell/network/_php_serve.sh"

source "${src_file}"
source "../../../src/shell/network/_py_serve.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_check_installed() { return 0; }
_echo_error() { printf '%b' "$1"; }
_echo_info() { :; }
php() { printf 'php %s\n' "$*"; }
python3() { printf 'python3 %s\n' "$*"; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __docroot__="$(mktemp -d)"
}

teardown() {
    rm -rf "${__docroot__}"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------
# PHP
#--------------------------------------------------

test_php_serve_should_serve_docroot_with_default_values() {
    assert_equals \
        "php -d memory-limit=-1 -S 127.0.0.1:8080 -t $(realpath "${__docroot__}")" \
        "$(_php_serve "${__docroot__}")"
}

test_php_serve_should_serve_docroot_with_given_ip_and_port() {
    assert_equals \
        "php -d memory-limit=-1 -S 0.0.0.0:9000 -t $(realpath "${__docroot__}")" \
        "$(_php_serve "${__docroot__}" '0.0.0.0' 9000)"
}

test_php_serve_fails_with_missing_argument() {
    assert_fails "_php_serve"
    assert_equals "_php_serve: some mandatory parameter is missing" "$(_php_serve 2>&1)"
}

test_php_serve_fails_with_nonexistent_folder() {
    assert_fails "_php_serve 'nonexistent'"
}

test_php_serve_fails_with_too_many_arguments() {
    assert_fails "_php_serve 'a' 'b' 'c' 'd'"
    assert_equals "_php_serve: too many arguments (4)" "$(_php_serve 'a' 'b' 'c' 'd' 2>&1)"
}

#--------------------------------------------------
# Python
#--------------------------------------------------

test_py_serve_should_serve_docroot_with_default_values() {
    assert_equals \
        "python3 -m http.server --directory $(realpath "${__docroot__}") --bind 127.0.0.1 8080" \
        "$(_py_serve "${__docroot__}")"
}

test_py_serve_should_serve_docroot_with_given_ip_and_port() {
    assert_equals \
        "python3 -m http.server --directory $(realpath "${__docroot__}") --bind 0.0.0.0 9000" \
        "$(_py_serve "${__docroot__}" '0.0.0.0' 9000)"
}

test_py_serve_fails_with_missing_argument() {
    assert_fails "_py_serve"
    assert_equals "_py_serve: some mandatory parameter is missing" "$(_py_serve 2>&1)"
}

test_py_serve_fails_with_nonexistent_folder() {
    assert_fails "_py_serve 'nonexistent'"
}

test_py_serve_fails_with_too_many_arguments() {
    assert_fails "_py_serve 'a' 'b' 'c' 'd'"
    assert_equals "_py_serve: too many arguments (4)" "$(_py_serve 'a' 'b' 'c' 'd' 2>&1)"
}
