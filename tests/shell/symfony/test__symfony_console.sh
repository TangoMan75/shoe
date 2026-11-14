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

source "../../../src/shell/symfony/_console.sh"
source "../../../src/shell/symfony/_phpunit.sh"
source "../../../src/shell/symfony/_sf_test.sh"

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
    __src_file__="$(realpath ../../../src/shell/symfony/_console.sh)"
    __old_pwd__="$(pwd)"
    __stub_dir__="$(mktemp -d)"
    __project__="${__stub_dir__}/project"
    __bin_dir__="${__stub_dir__}/bin"
    mkdir -p "${__project__}" "${__bin_dir__}"
    ln -s "$(command -v basename)" "${__bin_dir__}/basename"
    cd "${__project__}"
}

teardown() {
    cd "${__old_pwd__}"
    rm -rf "${__stub_dir__}"
}

_stub_symfony() {
    printf '#!/bin/sh\nexit 0\n' > "${__stub_dir__}/symfony"
    chmod +x "${__stub_dir__}/symfony"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "bash ${__src_file__}"
}

#--------------------------------------------------
# Console
#--------------------------------------------------

test_console_returns_symfony_console_when_cli_is_installed() {
    _stub_symfony
    PATH="${__stub_dir__}:${__old_path__}"

    assert_equals 'symfony console' "$(_console)"
}

test_console_returns_app_console_when_present() {
    touch app/console 2>/dev/null || { mkdir -p app; touch app/console; }
    PATH="${__bin_dir__}"

    assert_equals './app/console' "$(_console)"
    PATH="${__old_path__}"
}

test_console_returns_bin_console_when_present() {
    mkdir -p bin
    touch bin/console
    PATH="${__bin_dir__}"

    assert_equals './bin/console' "$(_console)"
    PATH="${__old_path__}"
}

test_console_exits_when_no_console_is_found() {
    PATH="${__bin_dir__}"
    __status__=0
    __output__="$(_console 2>&1)" || __status__=$?
    PATH="${__old_path__}"

    assert_equals 1 "${__status__}"
    assert_equals '"bash_unit" symfony console not found, try: '"'"'composer install'"'" "${__output__}"
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
