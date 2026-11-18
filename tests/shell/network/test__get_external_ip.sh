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

source "../../../src/shell/network/_get_external_ip.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%s' "$1"; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __old_path__="${PATH}"
    __tmp_dir__="$(mktemp -d)"
}

teardown() {
    PATH="${__old_path__}"
    rm -rf "${__tmp_dir__}"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "sh ../../../src/shell/network/_get_external_ip.sh"
}

#--------------------------------------------------
# Get external IP
#--------------------------------------------------

test_get_external_ip_should_return_ip_with_curl() {
    cat > "${__tmp_dir__}/curl" <<'STUB'
#!/bin/sh
printf '203.0.113.42\n'
STUB
    chmod +x "${__tmp_dir__}/curl"
    PATH="${__tmp_dir__}:${PATH}"

    assert_equals '203.0.113.42' "$(_get_external_ip)"
}

test_get_external_ip_should_return_ip_with_wget_when_curl_is_missing() {
    cat > "${__tmp_dir__}/wget" <<'STUB'
#!/bin/sh
printf '198.51.100.7\n'
STUB
    chmod +x "${__tmp_dir__}/wget"
    PATH="${__tmp_dir__}"

    assert_equals '198.51.100.7' "$(_get_external_ip)"
}

test_get_external_ip_fails_without_downloader() {
    PATH="${__tmp_dir__}"

    assert_fails "_get_external_ip"
    assert_equals \
        '_get_external_ip: curl or wget required\n' \
        "$(_get_external_ip 2>&1)"
}
