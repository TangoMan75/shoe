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

src_file="../../../src/shell/install/_uninstall.sh"

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%b' "$1"; }
_echo_info() { :; }
_remove_completion_autoload() { printf 'remove-autoload:%s:%s\n' "$1" "$2"; }
sudo() { printf 'sudo %s\n' "$*"; }

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
# Uninstall
#--------------------------------------------------

test_uninstall_should_remove_autoloads_completion_and_binary() {
    printf '#!/bin/bash\n' > "${__stub_dir__}/myscript-completion.sh"

    assert_equals \
        "remove-autoload:${HOME}/.zshrc:myscript
remove-autoload:${HOME}/.bashrc:myscript
remove-autoload:${HOME}/.profile:myscript
sudo rm -f /usr/local/bin/myscript" \
        "$(_uninstall "${__script__}")"
}

test_uninstall_should_remove_completion_file() {
    printf '#!/bin/bash\n' > "${__stub_dir__}/myscript-completion.sh"

    _uninstall "${__script__}" >/dev/null

    assert_fails "[ -f '${__stub_dir__}/myscript-completion.sh' ]"
}

test_uninstall_fails_with_missing_argument() {
    assert_fails "_uninstall"
    assert_equals '_uninstall: some mandatory parameter is missing' "$(_uninstall 2>&1)"
}

test_uninstall_fails_with_nonexistent_file() {
    assert_fails "_uninstall 'nonexistent.sh'"
}

test_uninstall_fails_with_too_many_arguments() {
    assert_fails "_uninstall 'a' 'b' 'c'"
    assert_equals '_uninstall: too many arguments (3)' "$(_uninstall 'a' 'b' 'c' 2>&1)"
}
