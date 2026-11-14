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

source "../../../src/bash/git/_parse_branch_subject.sh"
source "../../../src/bash/git/_parse_branch_ticket.sh"
source "../../../src/bash/git/_parse_branch_type.sh"
source "../../../src/bash/git/_parse_commit_pull_request.sh"
source "../../../src/bash/git/_parse_commit_scope.sh"
source "../../../src/bash/git/_parse_commit_subject.sh"
source "../../../src/bash/git/_parse_commit_ticket.sh"
source "../../../src/bash/git/_parse_commit_type.sh"

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "bash ../../../src/bash/git/_parse_branch_subject.sh"
}

#--------------------------------------------------

test_parse_branch_subject_should_remove_type_and_ticket() {
    assert_equals 'my-feature' "$(_parse_branch_subject 'feat/FOO-01/my-feature')"
}

test_parse_branch_subject_should_return_branch_without_type() {
    assert_equals 'my-feature' "$(_parse_branch_subject 'feat/my-feature')"
}

test_parse_branch_subject_should_return_unconventional_branch_unchanged() {
    assert_equals 'main' "$(_parse_branch_subject 'main')"
}

test_parse_branch_ticket_should_return_ticket() {
    assert_equals 'FOO-01' "$(_parse_branch_ticket 'feat/FOO-01/my-feature')"
}

test_parse_branch_ticket_should_return_empty_without_ticket() {
    assert_equals '' "$(_parse_branch_ticket 'feat/my-feature')"
    assert_equals '' "$(_parse_branch_ticket 'main')"
}

test_parse_branch_type_should_return_type() {
    assert_equals 'fix' "$(_parse_branch_type 'fix/FOO-01/my-feature')"
    assert_equals 'chore' "$(_parse_branch_type 'chore/update-dependencies')"
}

test_parse_branch_type_should_return_empty_for_unconventional_branch() {
    assert_equals '' "$(_parse_branch_type 'main')"
}

test_parse_commit_pull_request_should_return_number() {
    assert_equals '4321' "$(_parse_commit_pull_request 'feat(scope): Subject (FOO-01) (#4321)')"
}

test_parse_commit_pull_request_should_return_empty_without_pull_request() {
    assert_equals '' "$(_parse_commit_pull_request 'feat(scope): Subject (FOO-01)')"
}

test_parse_commit_scope_should_return_scope() {
    assert_equals 'scope' "$(_parse_commit_scope 'feat(scope): Subject (FOO-01)')"
}

test_parse_commit_scope_should_return_empty_without_scope() {
    assert_equals '' "$(_parse_commit_scope 'feat: Subject (FOO-01)')"
}

test_parse_commit_subject_should_remove_type_scope_ticket_and_pull_request() {
    assert_equals 'Subject' "$(_parse_commit_subject 'feat(scope): Subject (FOO-01) (#4321)')"
}

test_parse_commit_subject_should_keep_subject_without_annotations() {
    assert_equals 'Plain subject' "$(_parse_commit_subject 'Plain subject')"
}

test_parse_commit_ticket_should_return_ticket() {
    assert_equals 'FOO-01' "$(_parse_commit_ticket 'feat(scope): Subject (FOO-01)')"
}

test_parse_commit_ticket_should_return_empty_without_ticket() {
    assert_equals '' "$(_parse_commit_ticket 'feat(scope): Subject')"
}

test_parse_commit_type_should_return_type() {
    assert_equals 'feat' "$(_parse_commit_type 'feat(scope): Subject')"
    assert_equals 'fix' "$(_parse_commit_type 'fix!: Subject')"
}

test_parse_commit_type_should_return_empty_for_non_conventional_message() {
    assert_equals '' "$(_parse_commit_type 'Plain subject')"
}
