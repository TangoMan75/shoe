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

src_file="../../../src/shell/compatibility/_sha256.sh"

source "${src_file}"

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __old_path__="${PATH}"
    __stub_dir__="$(mktemp -d)"
}

teardown() {
    PATH="${__old_path__}"
    rm -rf "${__stub_dir__}"
}

_stub() {
    printf '#!/bin/sh\nexit 0\n' > "${__stub_dir__}/$1"
    chmod +x "${__stub_dir__}/$1"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------

test_sha256_returns_sha256sum() {
    _stub sha256sum
    PATH="${__stub_dir__}"

    assert_equals 'sha256sum' "$(_sha256)"
}

test_sha256_returns_shasum_with_algorithm() {
    _stub shasum
    PATH="${__stub_dir__}"

    assert_equals 'shasum -a 256' "$(_sha256)"
}

test_sha256_returns_openssl_with_digest() {
    _stub openssl
    PATH="${__stub_dir__}"

    assert_equals 'openssl dgst -sha256' "$(_sha256)"
}

test_sha256_fails_when_no_command_found() {
    PATH="${__stub_dir__}"
    __status__=0
    __output__="$(_sha256 2>&1)" || __status__=$?
    PATH="${__old_path__}"

    assert_equals 1 "${__status__}"
    assert_equals \
        'error: _sha256: no SHA-256 command found' \
        "${__output__}"
}

