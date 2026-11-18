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

source "../../../src/shell/network/_check_dns.sh"

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
}

teardown() {
    PATH="${__old_path__}"
    rm -rf "${__tmp_dir__}"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "sh ../../../src/shell/network/_check_dns.sh"
}

#--------------------------------------------------
# Check DNS
#--------------------------------------------------

test_check_dns_should_query_default_record_type() {
    cat > "${__tmp_dir__}/dig" <<'STUB'
#!/bin/sh
printf 'dig %s\n' "$*"
STUB
    chmod +x "${__tmp_dir__}/dig"
    PATH="${__tmp_dir__}:${PATH}"

    assert_equals \
        "dig \"example.com\" \"A\" +nostats +nocomments +nocmd
dig example.com A +nostats +nocomments +nocmd" \
        "$(_check_dns example.com)"
}

test_check_dns_should_query_given_record_type() {
    cat > "${__tmp_dir__}/dig" <<'STUB'
#!/bin/sh
printf 'dig %s\n' "$*"
STUB
    chmod +x "${__tmp_dir__}/dig"
    PATH="${__tmp_dir__}:${PATH}"

    assert_equals \
        "dig \"example.com\" \"MX\" +nostats +nocomments +nocmd
dig example.com MX +nostats +nocomments +nocmd" \
        "$(_check_dns example.com -t MX)"
}

test_check_dns_fails_with_missing_domain() {
    assert_fails "_check_dns"
}
