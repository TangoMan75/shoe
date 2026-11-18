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

source "../../../src/shell/git/_branch_exists.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_danger() { printf '%b' "$1"; }
_echo_error() { printf '%b' "$1"; }
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
    'show-ref --quiet --heads '*) exit "${FAKE_BRANCH_STATUS:-1}" ;;
    'show-ref --verify --quiet refs/remotes/origin/'*) exit "${FAKE_REMOTE_STATUS:-1}" ;;
    'show-ref --quiet '*) exit "${FAKE_ALL_STATUS:-1}" ;;
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
    assert_status_code 0 "sh ../../../src/shell/git/_branch_exists.sh"
}

#--------------------------------------------------
# Branch
#--------------------------------------------------

test_branch_exists_returns_true_for_existing_local_branch() {
    export FAKE_BRANCH_STATUS=0

    assert_equals 'true' "$(_branch_exists 'my-branch')"
}

test_branch_exists_returns_false_for_missing_local_branch() {
    export FAKE_BRANCH_STATUS=1

    assert_equals 'false' "$(_branch_exists 'my-branch')"
}

test_branch_exists_checks_remote_branch_with_remotes_flag() {
    export FAKE_REMOTE_STATUS=0

    assert_equals 'true' "$(_branch_exists -r 'my-branch')"
}

test_branch_exists_checks_all_references_with_list_all_flag() {
    export FAKE_ALL_STATUS=0

    assert_equals 'true' "$(_branch_exists -a 'my-branch')"
}

test_branch_exists_prints_command_when_verbose() {
    export FAKE_BRANCH_STATUS=0

    assert_equals \
        "git show-ref --quiet --heads my-branch && echo true || echo false
true" \
        "$(_branch_exists -v 'my-branch')"
}

test_branch_exists_fails_with_missing_argument() {
    assert_fails "_branch_exists"
    assert_equals "_branch_exists: some mandatory parameter is missing
usage:_branch_exists [branch name] -a (list all) -r (remotes only) -v (verbose) -h (help)" "$(_branch_exists)"
}

test_branch_exists_fails_with_too_many_arguments() {
    assert_fails "_branch_exists 'a' 'b'"
    assert "printf '%s' \"$(_branch_exists 'a' 'b')\" | grep -q 'too many arguments'"
}

test_branch_exists_fails_with_invalid_option() {
    assert_fails "_branch_exists -z"
    assert_equals 'error: invalid option "z"' "$(_branch_exists -z)"
}

test_branch_exists_fails_outside_git_repository() {
    export FAKE_TOPLEVEL=''

    assert_fails "_branch_exists 'my-branch'"
    assert_equals \
        'error: Not a git repository (or any of the parent directories)' \
        "$(_branch_exists 'my-branch')"
}
