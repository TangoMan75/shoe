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

src_file="../../../src/shell/install/_update.sh"

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%b' "$1"; }
_echo_info() { :; }
_is_installed() { return 1; }
_install() { printf 'install:%s:%s:%s\n' "$1" "$2" "$3"; }
_uninstall() { printf 'uninstall:%s:%s\n' "$1" "$2"; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __stub_dir__="$(mktemp -d)"
    __script__="${__stub_dir__}/myscript.sh"
    printf '#!/bin/sh\n' > "${__script__}"
}

teardown() {
    rm -rf "${__stub_dir__}"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "bash ${src_file}"
}

#--------------------------------------------------
# Update
#--------------------------------------------------

test_update_should_download_then_reinstall_script() {
    _is_installed() { [ "$1" = 'curl' ]; }
    _uninstall() { printf 'uninstall:%s:%s\n' "$1" "$2"; }
    _install() { printf 'install:%s:%s:%s\n' "$1" "$2" "$3"; }
    curl() { printf 'new content'; }

    assert_equals \
        "uninstall:$(realpath "${__script__}"):myscript
install:$(realpath "${__script__}"):myscript:false" \
        "$(_update "${__script__}" 'https://example.com/myscript.sh')"
    assert_equals 'new content' "$(cat "${__script__}")"
}

test_update_fails_when_no_downloader_is_available() {
    assert_fails "_update '${__script__}' 'https://example.com/myscript.sh'"
    assert_equals "\"${0}\" requires curl, try: \"sudo apt-get install -y curl\"" "$(_update "${__script__}" 'https://example.com/myscript.sh' 2>&1)"
}

test_update_fails_with_missing_arguments() {
    assert_fails "_update"
    assert_equals '_update: some mandatory parameter is missing' "$(_update 2>&1)"
}

test_update_fails_with_nonexistent_file() {
    assert_fails "_update 'nonexistent.sh' 'https://example.com/myscript.sh'"
}

test_update_fails_with_too_many_arguments() {
    assert_fails "_update 'a' 'b' 'c' 'd' 'e'"
    assert_equals '_update: too many arguments (5)' "$(_update 'a' 'b' 'c' 'd' 'e' 2>&1)"
}
