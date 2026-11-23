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

src_file="../../../src/shell/compatibility/_sed_i.sh"

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%b' "$1"; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __tmp__="$(mktemp)"
    printf 'alpha\nbeta\n' > "${__tmp__}"
}

teardown() {
    unset -f sed uname 2>/dev/null || true
    rm -f "${__tmp__}"
}

#--------------------------------------------------

test_sed_i_uses_gnu_syntax_on_linux() {
    uname() { printf 'Linux'; }
    sed() { printf '<%s>' "$@"; }

    assert_equals "<-i><-e><s/alpha/gamma/><${__tmp__}>" \
        "$(_sed_i 's/alpha/gamma/' "${__tmp__}")"
}

test_sed_i_uses_gnu_syntax_on_darwin_with_gnu_sed() {
    uname() { printf 'Darwin'; }
    sed() {
        if [ "$1" = '--version' ]; then
            printf 'sed (GNU sed) 4.9'
            return 0
        fi
        printf '<%s>' "$@"
    }

    assert_equals "<-i><-e><s/alpha/gamma/><${__tmp__}>" \
        "$(_sed_i 's/alpha/gamma/' "${__tmp__}")"
}

test_sed_i_uses_bsd_empty_suffix_on_darwin_with_bsd_sed() {
    uname() { printf 'Darwin'; }
    sed() {
        if [ "$1" = '--version' ]; then return 1; fi
        printf '<%s>' "$@"
    }

    assert_equals "<-i><><-e><s/alpha/gamma/><${__tmp__}>" \
        "$(_sed_i 's/alpha/gamma/' "${__tmp__}")"
}

test_sed_i_fails_with_missing_arguments() {
    assert_fails "_sed_i"
    assert_equals '_sed_i: some mandatory parameter is missing' "$(_sed_i 2>&1)"
}

test_sed_i_fails_with_nonexistent_file() {
    assert_fails "_sed_i 's/a/b/' './no-such-file'"
}

test_sed_i_should_edit_the_file_in_place() {
    _sed_i 's/alpha/gamma/' "${__tmp__}"

    assert_equals 'gamma' "$(sed -n '1p' "${__tmp__}")"
    assert_equals 'beta' "$(sed -n '2p' "${__tmp__}")"
}
