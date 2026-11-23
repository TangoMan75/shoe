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

source "../../../src/shell/git/_blob_exists.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_danger() { printf '%s' "$1"; }
_echo_error() { printf '%s' "$1"; }
_echo_info() { printf '%b' "$1"; }
_echo_primary() { printf '%b' "$1"; }
_echo_success() { printf '%b' "$1"; }
_echo_warning() { printf '%b' "$1"; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __old_path__="${PATH}"
    __tmp_dir__="$(mktemp -d)"

    cat > "${__tmp_dir__}/git" <<'STUB'
#!/bin/sh
case "$*" in
    'rev-parse --show-toplevel') printf '/repo\n' ;;
    'cat-file -e '*) exit "${FAKE_BLOB_STATUS:-1}" ;;
    *) exit 1 ;;
esac
STUB
    chmod +x "${__tmp_dir__}/git"
    PATH="${__tmp_dir__}:${__old_path__}"
}

teardown() {
    PATH="${__old_path__}"
    rm -rf "${__tmp_dir__}"
}

#--------------------------------------------------
# Blob
#--------------------------------------------------

test_blob_exists_should_return_true_for_existing_blob() {
    export FAKE_BLOB_STATUS=0

    assert_equals 'true' "$(_blob_exists 'abc123')"
}

test_blob_exists_should_return_false_for_missing_blob() {
    export FAKE_BLOB_STATUS=1

    assert_equals 'false' "$(_blob_exists 'abc123')"
}

test_blob_exists_should_print_command_when_verbose() {
    export FAKE_BLOB_STATUS=0

    assert_equals \
        'git cat-file -e "abc123^{blob}"
true' \
        "$(_blob_exists 'abc123' -v)"
}

test_blob_exists_fails_with_missing_argument() {
    assert_fails "_blob_exists"
}
