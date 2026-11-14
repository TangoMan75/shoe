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

source "../../../src/bash/git/_format_branch_subject.sh"
source "../../../src/bash/git/_format_commit_subject.sh"
source "../../../src/bash/git/_format_ticket.sh"
source "../../../src/bash/git/_format_type.sh"

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "bash ../../../src/bash/git/_format_branch_subject.sh"
}

#--------------------------------------------------

test_format_branch_subject_should_remove_type_and_ticket() {
    assert_equals 'my-feature' "$(_format_branch_subject 'feat/FOO-01/my-feature')"
}

test_format_branch_subject_should_lowercase_and_replace_special_characters() {
    assert_equals 'my_feature' "$(_format_branch_subject 'My Feature!')"
}

test_format_branch_subject_should_remove_trailing_underscores() {
    assert_equals 'feature' "$(_format_branch_subject 'feature!')"
}

test_format_commit_subject_should_remove_annotations() {
    assert_equals 'Hello world' "$(_format_commit_subject 'feat(scope): Hello world (FOO-01) (#42)')"
}

test_format_commit_subject_should_squeeze_spaces() {
    assert_equals 'Hello world' "$(_format_commit_subject 'Hello     world')"
}

test_format_ticket_should_uppercase_and_remove_special_characters() {
    assert_equals 'FOO-01' "$(_format_ticket ' foo-01! ')"
    assert_equals 'FOO_01' "$(_format_ticket 'foo_01')"
}

test_format_type_should_lowercase_and_underscore_special_characters() {
    assert_equals 'feat_ure' "$(_format_type 'Feat ure!')"
}

test_format_type_should_remove_trailing_underscores() {
    assert_equals 'feat' "$(_format_type 'feat!')"
}
