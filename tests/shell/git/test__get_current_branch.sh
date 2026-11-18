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

source "../../../src/shell/git/_get_current_branch.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_danger() { printf '%b' "$1"; }
_echo_info() { printf '%b' "$1"; }
_echo_primary() { printf '%b' "$1"; }
_echo_success() { printf '%b' "$1"; }
_echo_warning() { printf '%b' "$1"; }


#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    OPTIND=1
    __old_path__="${PATH}"
    __stub_dir__="$(mktemp -d)"

    cat > "${__stub_dir__}/git" <<'STUB'
#!/bin/bash
case "$*" in
    'rev-parse --show-toplevel') printf '%s\n' "${FAKE_TOPLEVEL-/repo}" ;;
    'rev-parse --abbrev-ref HEAD') printf '%s\n' "${FAKE_BRANCH:-main}" ;;
    *) exit 1 ;;
esac
STUB
    chmod +x "${__stub_dir__}/git"
    PATH="${__stub_dir__}:${__old_path__}"
}

teardown() {
    PATH="${__old_path__}"
    rm -rf "${__stub_dir__}"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "sh ../../../src/shell/git/_get_current_branch.sh"
}

#--------------------------------------------------

test_get_current_branch_should_return_branch_name() {
    export FAKE_BRANCH='feat/FOO-01/my-feature'

    assert_equals 'feat/FOO-01/my-feature' "$(_get_current_branch)"
}

test_get_current_branch_should_print_command_when_verbose() {
    export FAKE_BRANCH='main'

    assert_equals \
        "git rev-parse --abbrev-ref HEAD 2>/dev/null
main" \
        "$(_get_current_branch -v)"
}

test_get_current_branch_display_help_when_help_flag_is_used() {
    assert_equals \
        '_get_current_branch
description:Get current branch name
usage:_get_current_branch -v (verbose) -h (help)' \
        "$(_get_current_branch -h)"
}

test_get_current_branch_fails_with_invalid_option() {
    assert_fails "_get_current_branch -z"
    assert_equals 'error: invalid option "z"' "$(_get_current_branch -z)"
}

test_get_current_branch_fails_outside_git_repository() {
    export FAKE_TOPLEVEL=''

    assert_fails "_get_current_branch"
    assert_equals \
        'error: Not a git repository (or any of the parent directories)' \
        "$(_get_current_branch)"
}
