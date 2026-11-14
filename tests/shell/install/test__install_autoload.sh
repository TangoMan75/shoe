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

source "../../../src/shell/compatibility/_sed_i.sh"
source "../../../src/shell/install/_remove_completion_autoload.sh"
source "../../../src/shell/install/_set_completion_autoload.sh"
source "../../../src/shell/strings/_collapse_blank_lines.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%b' "$1"; }
_echo_info() { :; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __stub_dir__="$(mktemp -d)"
    __config__="${__stub_dir__}/config"
    __script__="${__stub_dir__}/myscript.sh"
    printf '#!/bin/sh\n' > "${__script__}"
}

teardown() {
    rm -rf "${__stub_dir__}"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "bash ../../../src/shell/install/_remove_completion_autoload.sh"
}

#--------------------------------------------------
# Remove autoload
#--------------------------------------------------

test_remove_completion_autoload_should_remove_autoload_block() {
    printf 'before\n###> my-alias\nsource /path/to/completion.sh\n###< my-alias\nafter\n' > "${__config__}"

    _remove_completion_autoload "${__config__}" 'my-alias'

    assert_equals "$(printf 'before\nafter')" "$(cat "${__config__}")"
}

test_remove_completion_autoload_should_leave_unrelated_content_unchanged() {
    printf 'before\nafter\n' > "${__config__}"

    _remove_completion_autoload "${__config__}" 'my-alias'

    assert_equals "$(printf 'before\nafter')" "$(cat "${__config__}")"
}

test_remove_completion_autoload_fails_with_missing_argument() {
    assert_fails "_remove_completion_autoload"
    assert_equals '_remove_completion_autoload: some mandatory parameter is missing' "$(_remove_completion_autoload 2>&1)"
}

test_remove_completion_autoload_fails_with_nonexistent_file() {
    assert_fails "_remove_completion_autoload 'nonexistent' 'my-alias'"
}

test_remove_completion_autoload_fails_with_too_many_arguments() {
    assert_fails "_remove_completion_autoload 'a' 'b' 'c'"
    assert_equals '_remove_completion_autoload: too many arguments (3)' "$(_remove_completion_autoload 'a' 'b' 'c' 2>&1)"
}

#--------------------------------------------------
# Set autoload
#--------------------------------------------------

test_set_completion_autoload_should_add_autoload_block() {
    printf '' > "${__config__}"
    printf '#!/bin/bash\n' > "${__stub_dir__}/my-alias-completion.sh"
    __completion__="$(realpath "${__stub_dir__}")/my-alias-completion.sh"

    _set_completion_autoload "${__config__}" "${__script__}" 'my-alias'

    assert "grep -q '^###> my-alias$' '${__config__}'"
    assert "grep -q '^source ${__completion__}$' '${__config__}'"
    assert "grep -q '^###< my-alias$' '${__config__}'"
}

test_set_completion_autoload_should_use_default_alias() {
    printf '' > "${__config__}"
    printf '#!/bin/bash\n' > "${__stub_dir__}/myscript-completion.sh"

    _set_completion_autoload "${__config__}" "${__script__}"

    assert "grep -q '^###> myscript$' '${__config__}'"
}

test_set_completion_autoload_should_replace_existing_autoload_block() {
    printf '###> my-alias\nsource old.sh\n###< my-alias\n' > "${__config__}"
    printf '#!/bin/bash\n' > "${__stub_dir__}/my-alias-completion.sh"
    __completion__="$(realpath "${__stub_dir__}")/my-alias-completion.sh"

    _set_completion_autoload "${__config__}" "${__script__}" 'my-alias'

    assert_fails "grep -q 'source old.sh' '${__config__}'"
    assert "grep -q '^source ${__completion__}$' '${__config__}'"
}

test_set_completion_autoload_fails_with_missing_arguments() {
    assert_fails "_set_completion_autoload"
    assert_equals '_set_completion_autoload: some mandatory parameter is missing' "$(_set_completion_autoload 2>&1)"
}

test_set_completion_autoload_fails_with_missing_script() {
    printf '' > "${__config__}"

    assert_fails "_set_completion_autoload '${__config__}'"
    assert_equals '_set_completion_autoload: some mandatory parameter is missing' "$(_set_completion_autoload "${__config__}" 2>&1)"
}

test_set_completion_autoload_fails_with_nonexistent_config() {
    assert_fails "_set_completion_autoload 'nonexistent' '${__script__}' 'my-alias'"
}

test_set_completion_autoload_fails_with_nonexistent_script() {
    printf '' > "${__config__}"

    assert_fails "_set_completion_autoload '${__config__}' 'nonexistent.sh' 'my-alias'"
}

test_set_completion_autoload_fails_with_too_many_arguments() {
    assert_fails "_set_completion_autoload 'a' 'b' 'c' 'd'"
    assert_equals '_set_completion_autoload: too many arguments (4)' "$(_set_completion_autoload 'a' 'b' 'c' 'd' 2>&1)"
}
