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

src_file="../../../src/shell/system/_pwd.sh"

source "${src_file}"

#--------------------------------------------------
# Helpers
#--------------------------------------------------

teardown() {
    unset -f realpath pwd 2>/dev/null || true
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------

test_pwd_returns_script_directory_when_not_installed_in_bin_folder() {
    realpath() { printf '/opt/scripts/my-script'; }

    assert_equals '/opt/scripts' "$(_pwd)"
}

test_pwd_returns_current_directory_when_script_is_in_usr_bin() {
    realpath() { printf '/usr/bin/my-script'; }
    pwd() { printf '/current/directory'; }

    assert_equals '/current/directory' "$(_pwd)"
}

test_pwd_returns_current_directory_when_script_is_in_usr_local_bin() {
    realpath() { printf '/usr/local/bin/my-script'; }
    pwd() { printf '/current/directory'; }

    assert_equals '/current/directory' "$(_pwd)"
}

test_pwd_returns_current_directory_when_script_is_in_local_bin() {
    realpath() { printf '%s/.local/bin/my-script' "${HOME}"; }
    pwd() { printf '/current/directory'; }

    assert_equals '/current/directory' "$(_pwd)"
}
