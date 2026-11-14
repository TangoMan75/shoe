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

source "../../../src/shell/npm/_npm_build.sh"
source "../../../src/shell/npm/_npm_lint.sh"
source "../../../src/shell/npm/_npm_test.sh"
source "../../../src/shell/npm/_npm_watch.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_check_installed() { return 0; }
_echo_error() { printf '%b' "$1"; }
_echo_info() { :; }
npm() { printf 'npm %s\n' "$*"; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __destination__="$(mktemp -d)"
}

teardown() {
    rm -rf "${__destination__}"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "bash ../../../src/shell/npm/_npm_build.sh"
}

#--------------------------------------------------
# Build
#--------------------------------------------------

test_npm_build_should_build_to_destination_folder() {
    assert_equals 'npm run build' "$(_npm_build "${__destination__}")"
}

test_npm_build_should_remove_destination_folder() {
    _npm_build "${__destination__}" >/dev/null

    assert_fails "[ -d '${__destination__}' ]"
}

test_npm_build_fails_with_missing_argument() {
    assert_fails "_npm_build"
    assert_equals "_npm_build: some mandatory parameter is missing" "$(_npm_build 2>&1)"
}

test_npm_build_fails_with_nonexistent_folder() {
    assert_fails "_npm_build 'nonexistent'"
}

test_npm_build_fails_with_too_many_arguments() {
    assert_fails "_npm_build 'a' 'b'"
    assert_equals "_npm_build: too many arguments (2)" "$(_npm_build 'a' 'b' 2>&1)"
}

#--------------------------------------------------
# Other scripts
#--------------------------------------------------

test_npm_lint_should_run_lint_script() {
    assert_equals 'npm run lint' "$(_npm_lint)"
}

test_npm_test_should_run_test_script() {
    assert_equals 'npm test' "$(_npm_test)"
}

test_npm_watch_should_run_watch_script() {
    assert_equals 'npm run watch' "$(_npm_watch)"
}
