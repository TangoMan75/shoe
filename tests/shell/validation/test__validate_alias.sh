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

src_file="../../../src/shell/validation/_validate_alias.sh"

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%b' "$1"; }

#--------------------------------------------------

test_validate_alias_should_accept_a_plain_name() {
    assert_status_code 0 "_validate_alias 'myscript' '_copy_install'"
}

test_validate_alias_should_accept_dots_and_dashes_after_the_first_character() {
    assert_status_code 0 "_validate_alias 'my.script-1' '_copy_install'"
}

test_validate_alias_should_reject_a_slash() {
    assert_fails "_validate_alias '../../etc/cron.d/tool' '_copy_install'"
    assert_equals \
        '_copy_install: invalid alias "../../etc/cron.d/tool"' \
        "$(_validate_alias '../../etc/cron.d/tool' '_copy_install' 2>&1)"
}

test_validate_alias_should_reject_a_hidden_name() {
    assert_fails "_validate_alias '.profile' '_copy_install'"
}

test_validate_alias_should_reject_a_parent_reference() {
    assert_fails "_validate_alias '..' '_copy_install'"
}

test_validate_alias_should_reject_an_empty_name() {
    assert_fails "_validate_alias '' '_copy_install'"
}

test_validate_alias_fails_with_missing_arguments() {
    assert_fails "_validate_alias"
    assert_equals '_validate_alias: some mandatory parameter is missing' \
        "$(_validate_alias 2>&1)"
}

test_validate_alias_fails_with_too_many_arguments() {
    assert_fails "_validate_alias 'a' 'b' 'c'"
    assert_equals '_validate_alias: too many arguments (3)' \
        "$(_validate_alias 'a' 'b' 'c' 2>&1)"
}
