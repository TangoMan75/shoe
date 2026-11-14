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

source "../../../src/bash/git/_parse_branch_ticket.sh"
source "../../../src/bash/git/_parse_branch_type.sh"
source "../../../src/bash/git/_parse_commit_pull_request.sh"
source "../../../src/bash/git/_parse_commit_scope.sh"
source "../../../src/bash/git/_parse_commit_subject.sh"
source "../../../src/bash/git/_parse_commit_ticket.sh"
source "../../../src/bash/git/_parse_commit_type.sh"
source "../../../src/bash/git/_get_branch_ticket.sh"
source "../../../src/bash/git/_get_branch_type.sh"
source "../../../src/bash/git/_get_commit_body.sh"
source "../../../src/bash/git/_get_commit_pull_request.sh"
source "../../../src/bash/git/_get_commit_scope.sh"
source "../../../src/bash/git/_get_commit_subject.sh"
source "../../../src/bash/git/_get_commit_ticket.sh"
source "../../../src/bash/git/_get_commit_type.sh"
source "../../../src/shell/strings/_trim.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_danger() { printf '%b' "$1"; }

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
    '--no-pager log -1 --pretty=format:%s') printf '%s' "${FAKE_SUBJECT:-}" ;;
    '--no-pager log -1 --pretty=format:%b') printf '%s' "${FAKE_BODY:-}" ;;
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
    assert_status_code 0 "bash ../../../src/bash/git/_get_commit_subject.sh"
}

#--------------------------------------------------

test_get_commit_subject_should_return_subject() {
    export FAKE_SUBJECT='feat(scope): Hello world (FOO-02) (#42)'

    assert_equals 'Hello world' "$(_get_commit_subject)"
}

test_get_commit_scope_should_return_scope() {
    export FAKE_SUBJECT='feat(scope): Hello world (FOO-02)'

    assert_equals 'scope' "$(_get_commit_scope)"
}

test_get_commit_pull_request_should_return_number() {
    export FAKE_SUBJECT='feat(scope): Hello world (FOO-02) (#42)'

    assert_equals '42' "$(_get_commit_pull_request)"
}

test_get_commit_body_should_return_trimmed_body() {
    export FAKE_BODY='  This is the body.  '

    assert_equals 'This is the body.' "$(_get_commit_body)"
}

test_get_commit_type_should_prefer_branch_type() {
    export FAKE_BRANCH='fix/ABC-09/my-feature'
    export FAKE_SUBJECT='feat(scope): Hello world'

    assert_equals 'fix' "$(_get_commit_type)"
}

test_get_commit_type_should_fallback_to_commit_type() {
    export FAKE_BRANCH='main'
    export FAKE_SUBJECT='feat(scope): Hello world'

    assert_equals 'feat' "$(_get_commit_type)"
}

test_get_commit_ticket_should_prefer_branch_ticket() {
    export FAKE_BRANCH='fix/ABC-09/my-feature'
    export FAKE_SUBJECT='feat(scope): Hello world (FOO-02)'

    assert_equals 'ABC-09' "$(_get_commit_ticket)"
}

test_get_commit_ticket_should_fallback_to_commit_ticket() {
    export FAKE_BRANCH='main'
    export FAKE_SUBJECT='feat(scope): Hello world (FOO-02)'

    assert_equals 'FOO-02' "$(_get_commit_ticket)"
}

test_get_commit_subject_fails_outside_git_repository() {
    export FAKE_TOPLEVEL=''

    assert_fails "_get_commit_subject"
    assert_equals \
        'error: Not a git repository (or any of the parent directories)' \
        "$(_get_commit_subject)"
}
