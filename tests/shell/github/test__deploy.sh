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

src_abs="$(realpath '../../../src/shell/github/_deploy.sh')"

source "../../../src/shell/github/_deploy.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%b' "$1"; }
_echo_info() { :; }
git() {
    case "$*" in
        'rev-parse --show-toplevel') printf '%s\n' "${__toplevel-/repo}" ;;
        'subtree split --prefix dist HEAD') printf 'abc123\n' ;;
        'push origin abc123:refs/heads/gh-pages --force') printf 'pushed\n' ;;
        *) return 1 ;;
    esac
}

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __old_pwd__="$(pwd)"
    __stub_dir__="$(mktemp -d)"
    mkdir -p "${__stub_dir__}/dist"
    cd "${__stub_dir__}"
}

teardown() {
    cd "${__old_pwd__}"
    rm -rf "${__stub_dir__}"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "bash ${src_abs}"
}

#--------------------------------------------------

test_deploy_should_push_source_folder_to_gh_pages() {
    assert_equals 'pushed' "$(_deploy 'dist')"
}

test_deploy_fails_with_missing_argument() {
    assert_fails "_deploy"
    assert_equals '_deploy: some mandatory parameter is missing' "$(_deploy 2>&1)"
}

test_deploy_fails_with_nonexistent_folder() {
    assert_fails "_deploy 'nonexistent'"
}

test_deploy_fails_with_too_many_arguments() {
    assert_fails "_deploy 'a' 'b'"
    assert_equals '_deploy: too many arguments (2)' "$(_deploy 'a' 'b' 2>&1)"
}

test_deploy_fails_outside_git_repository() {
    __toplevel=''

    assert_fails "_deploy 'dist'"
    assert_equals 'not a git repository (or any of the parent directories)' "$(_deploy 'dist' 2>&1)"
}
