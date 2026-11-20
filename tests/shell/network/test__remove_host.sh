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

src_file="../../../src/shell/network/_remove_host.sh"

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%b' "$1"; }
_echo_info() { :; }
sudo() {
    if [ "$1" = 'cp' ]; then
        cp "$2" "$3"

        return $?
    fi

    printf 'sudo %s\n' "$*"
}

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __tmp_dir__="$(mktemp -d)"
    HOSTS_FILE="${__tmp_dir__}/hosts"
    printf '%s\n' \
        '127.0.0.1    localhost' \
        '127.0.0.1    example.test alias.test' \
        '127.0.0.1    other.test' > "${HOSTS_FILE}"
}

teardown() {
    rm -rf "${__tmp_dir__}"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------
# Remove host
#--------------------------------------------------

test_remove_host_should_remove_entry_and_every_alias() {
    _remove_host 'example.test'

    assert_fails "grep -q 'example.test' '${HOSTS_FILE}'"
    assert "grep -q 'other.test' '${HOSTS_FILE}'"
}

test_remove_host_should_remove_host_from_alias_list() {
    _remove_host 'alias.test'

    assert_fails "grep -q 'example.test' '${HOSTS_FILE}'"
    assert "grep -q 'other.test' '${HOSTS_FILE}'"
}

test_remove_host_should_keep_untouched_lines() {
    _remove_host 'example.test'

    assert "grep -q '^127.0.0.1    localhost$' '${HOSTS_FILE}'"
}

test_remove_host_should_reject_a_hostile_hostname() {
    assert_fails "_remove_host 'example.test\"; echo PWNED'"
    assert_equals '_remove_host: invalid hostname "example.test"; echo PWNED"' \
        "$(_remove_host 'example.test"; echo PWNED' 2>&1)"
    assert "grep -q 'example.test' '${HOSTS_FILE}'"
}

test_remove_host_fails_with_missing_argument() {
    assert_fails "_remove_host"
    assert_equals "_remove_host: some mandatory parameter is missing" "$(_remove_host 2>&1)"
}
