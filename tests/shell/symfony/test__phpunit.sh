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

source "../../../src/shell/symfony/_phpunit.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%b' "$1"; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __src_file__="$(realpath ../../../src/shell/symfony/_phpunit.sh)"
    __old_pwd__="$(pwd)"
    __stub_dir__="$(mktemp -d)"
    __project__="${__stub_dir__}/project"
    mkdir -p "${__project__}"
    cd "${__project__}"
}

teardown() {
    cd "${__old_pwd__}"
    rm -rf "${__stub_dir__}"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "bash ${__src_file__}"
}

#--------------------------------------------------
# PHPUnit
#--------------------------------------------------

test_phpunit_returns_vendor_binary_when_present() {
    mkdir -p vendor/bin
    touch vendor/bin/phpunit

    assert_equals './vendor/bin/phpunit' "$(_phpunit)"
}

test_phpunit_returns_simple_phpunit_when_present() {
    mkdir -p vendor/bin
    touch vendor/bin/simple-phpunit

    assert_equals './vendor/bin/simple-phpunit' "$(_phpunit)"
}

test_phpunit_returns_bridge_binary_when_present() {
    mkdir -p vendor/symfony/phpunit-bridge/bin
    touch vendor/symfony/phpunit-bridge/bin/simple-phpunit

    assert_equals './vendor/symfony/phpunit-bridge/bin/simple-phpunit' "$(_phpunit)"
}

test_phpunit_returns_bin_phpunit_when_present() {
    mkdir -p bin
    touch bin/phpunit

    assert_equals './bin/phpunit' "$(_phpunit)"
}

test_phpunit_fails_when_no_binary_is_found() {
    assert_fails "_phpunit"
    assert_equals \
        "\"bash_unit\" requires phpunit, try: 'composer install'" \
        "$(_phpunit 2>&1)"
}
