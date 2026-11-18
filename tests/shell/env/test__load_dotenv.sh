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

source "../../../src/shell/env/_load_dotenv.sh"
source "../../../src/shell/env/_load_env.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%s' "$1"; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __tmp_dir__="$(realpath "$(mktemp -d)")"
}

teardown() {
    rm -rf "${__tmp_dir__}"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "sh ../../../src/shell/env/_load_dotenv.sh"
}

#--------------------------------------------------
# Load dotenv
#--------------------------------------------------

test_load_dotenv_should_load_environment_specific_file() {
    printf 'SHOE_TEST_ENV=production\n' > "${__tmp_dir__}/.env.production"
    printf 'SHOE_TEST_ENV=local\n' > "${__tmp_dir__}/.env.local"

    _load_dotenv production "${__tmp_dir__}"

    assert_equals 'production' "${SHOE_TEST_ENV}"
}

test_load_dotenv_should_fallback_to_env_local() {
    printf 'SHOE_TEST_ENV=local\n' > "${__tmp_dir__}/.env.local"

    _load_dotenv production "${__tmp_dir__}"

    assert_equals 'local' "${SHOE_TEST_ENV}"
}

test_load_dotenv_should_fallback_to_env() {
    printf 'SHOE_TEST_ENV=default\n' > "${__tmp_dir__}/.env"

    _load_dotenv production "${__tmp_dir__}"

    assert_equals 'default' "${SHOE_TEST_ENV}"
}

test_load_dotenv_fails_without_dotenv_file() {
    assert_fails "_load_dotenv production '${__tmp_dir__}'"
    assert_equals \
        "_load_dotenv: no dotenv file found in \"${__tmp_dir__}\"\n" \
        "$(_load_dotenv production "${__tmp_dir__}" 2>&1)"
}
