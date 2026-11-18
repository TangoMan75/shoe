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

source "../../../src/shell/git/_is_cherry_pick_in_progress.sh"

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
    __git_dir__="${__stub_dir__}/git-dir"
    mkdir -p "${__git_dir__}"

    cat > "${__stub_dir__}/git" <<'STUB'
#!/bin/bash
case "$*" in
    'rev-parse --show-toplevel') printf '%s\n' "${FAKE_TOPLEVEL-/repo}" ;;
    'rev-parse --git-dir') printf '%s\n' "${FAKE_GIT_DIR:-/nonexistent/git-dir}" ;;
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
    assert_status_code 0 "sh ../../../src/shell/git/_is_cherry_pick_in_progress.sh"
}

#--------------------------------------------------
# In progress
#--------------------------------------------------

test_is_cherry_pick_in_progress_returns_false_without_cherry_pick_file() {
    export FAKE_GIT_DIR="${__git_dir__}"

    assert_equals 'false' "$(_is_cherry_pick_in_progress)"
}

test_is_cherry_pick_in_progress_returns_true_with_cherry_pick_file() {
    export FAKE_GIT_DIR="${__git_dir__}"
    printf 'commit' > "${__git_dir__}/CHERRY_PICK_HEAD"

    assert_equals 'true' "$(_is_cherry_pick_in_progress)"
}

test_is_cherry_pick_in_progress_display_help_when_help_flag_is_used() {
    assert "printf '%s' \"$(_is_cherry_pick_in_progress -h)\" | grep -q 'Check cherry-pick is in progress'"
}
