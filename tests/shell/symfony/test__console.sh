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

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%b' "$1"; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __old_path__="${PATH}"
    __old_pwd__="$(pwd)"
    __stub_dir__="$(mktemp -d)"
    __project__="${__stub_dir__}/project"
    __bin_dir__="${__stub_dir__}/bin"
    mkdir -p "${__project__}" "${__bin_dir__}"
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
    assert_equals "\"$(basename "${0}")\" symfony console not found, try: 'composer install'" "${__output__}"
}
