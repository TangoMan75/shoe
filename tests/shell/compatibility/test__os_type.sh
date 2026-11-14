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

src_file="../../../src/shell/compatibility/_os_type.sh"

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

_stub_uname() {
    cat > "${__stub_dir__}/uname" <<EOF
#!/bin/sh
printf '%s\n' '$1'
EOF
    chmod +x "${__stub_dir__}/uname"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------
# uname
#--------------------------------------------------

test_os_type_returns_linux_for_linux() {
    _stub_uname 'Linux'
    PATH="${__stub_dir__}"

    assert_equals 'linux' "$(_os_type)"
}

test_os_type_returns_darwin_for_darwin() {
    _stub_uname 'Darwin'
    PATH="${__stub_dir__}"

    assert_equals 'darwin' "$(_os_type)"
}

test_os_type_returns_bsd_for_freebsd() {
    _stub_uname 'FreeBSD'
    PATH="${__stub_dir__}"

    assert_equals 'bsd' "$(_os_type)"
}

test_os_type_returns_bsd_for_openbsd() {
    _stub_uname 'OpenBSD'
    PATH="${__stub_dir__}"

    assert_equals 'bsd' "$(_os_type)"
}

test_os_type_returns_cygwin_for_cygwin() {
    _stub_uname 'CYGWIN_NT-10.0'
    PATH="${__stub_dir__}"

    assert_equals 'cygwin' "$(_os_type)"
}

test_os_type_returns_msys_for_msys() {
    _stub_uname 'MSYS_NT-10.0'
    PATH="${__stub_dir__}"

    assert_equals 'msys' "$(_os_type)"
}

test_os_type_returns_msys_for_mingw() {
    _stub_uname 'MINGW64_NT-10.0'
    PATH="${__stub_dir__}"

    assert_equals 'msys' "$(_os_type)"
}

test_os_type_prefers_uname_over_ostype() {
    _stub_uname 'Darwin'
    PATH="${__stub_dir__}"
    OSTYPE='linux-gnu'

    assert_equals 'darwin' "$(_os_type)"
}

#--------------------------------------------------
# OSTYPE fallback
#--------------------------------------------------

test_os_type_falls_back_to_ostype_for_linux() {
    PATH="${__stub_dir__}"
    OSTYPE='linux-gnu'

    assert_equals 'linux' "$(_os_type)"
}

test_os_type_falls_back_to_ostype_for_darwin() {
    PATH="${__stub_dir__}"
    OSTYPE='darwin20.0'

    assert_equals 'darwin' "$(_os_type)"
}

test_os_type_falls_back_to_ostype_for_freebsd() {
    PATH="${__stub_dir__}"
    OSTYPE='freebsd13.2'

    assert_equals 'bsd' "$(_os_type)"
}

test_os_type_falls_back_to_ostype_for_msys() {
    PATH="${__stub_dir__}"
    OSTYPE='msys'

    assert_equals 'msys' "$(_os_type)"
}

#--------------------------------------------------
# Errors
#--------------------------------------------------

test_os_type_fails_for_unknown_system() {
    _stub_uname 'Plan9'
    PATH="${__stub_dir__}"
    __status__=0
    __output__="$(_os_type 2>&1)" || __status__=$?
    PATH="${__old_path__}"

    assert_equals 1 "${__status__}"
    assert_equals \
        'error: _os_type: unknown os type: "Plan9"' \
        "${__output__}"
}

test_os_type_fails_without_uname_and_ostype() {
    PATH="${__stub_dir__}"
    OSTYPE=''
    __status__=0
    __output__="$(_os_type 2>&1)" || __status__=$?

    assert_equals 1 "${__status__}"
    assert_equals \
        'error: _os_type: unknown os type: ""' \
        "${__output__}"
}

