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
source "../../../src/shell/network/_set_host.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%b' "$1"; }
_echo_info() { :; }
_sed_i() { printf 'sed -i'; }
sudo() { printf 'sudo %s\n' "$*"; }

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------
# Remove host
#--------------------------------------------------

test_remove_host_should_remove_host_entry() {
    assert_equals 'sudo sed -i /example.test/d /etc/hosts' "$(_remove_host 'example.test')"
}

test_remove_host_fails_with_missing_argument() {
    assert_fails "_remove_host"
    assert_equals "_remove_host: some mandatory parameter is missing" "$(_remove_host 2>&1)"
}

#--------------------------------------------------
# Set host
#--------------------------------------------------

test_set_host_should_remove_existing_entry_then_add_new_one() {
    _remove_host() { printf 'remove:%s\n' "$1"; }

    assert_equals \
        "remove:example.test
sudo /bin/sh -c echo \"127.0.0.1    example.test\" >> /etc/hosts" \
        "$(_set_host 'example.test')"
}

test_set_host_fails_with_missing_argument() {
    assert_fails "_set_host"
    assert_equals "_set_host: some mandatory parameter is missing" "$(_set_host 2>&1)"
}
