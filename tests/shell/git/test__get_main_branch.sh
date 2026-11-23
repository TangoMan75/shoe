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

source "../../../src/shell/git/_get_main_branch.sh"

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
    'show-ref --heads --quiet main') exit "${FAKE_MAIN_STATUS:-1}" ;;
    'show-ref --quiet refs/remotes/origin/main') exit "${FAKE_REMOTE_MAIN_STATUS:-1}" ;;
    'show-ref --heads --quiet master') exit "${FAKE_MASTER_STATUS:-1}" ;;
    'show-ref --quiet refs/remotes/origin/master') exit "${FAKE_REMOTE_MASTER_STATUS:-1}" ;;
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

test_get_main_branch_should_return_main_when_it_exists() {
    export FAKE_MAIN_STATUS=0

    assert_equals 'main' "$(_get_main_branch)"
}

test_get_main_branch_should_return_master_when_main_is_missing() {
    export FAKE_MAIN_STATUS=1
    export FAKE_REMOTE_MAIN_STATUS=1
    export FAKE_MASTER_STATUS=0

    assert_equals 'master' "$(_get_main_branch)"
}

test_get_main_branch_should_return_empty_when_no_main_branch_exists() {
    export FAKE_MAIN_STATUS=1
    export FAKE_REMOTE_MAIN_STATUS=1
    export FAKE_MASTER_STATUS=1
    export FAKE_REMOTE_MASTER_STATUS=1

    assert_equals '' "$(_get_main_branch)"
}

test_get_main_branch_display_help_when_help_flag_is_used() {
    assert "printf '%s' \"$(_get_main_branch -h)\" | grep -q 'Get main branch name'"
}
