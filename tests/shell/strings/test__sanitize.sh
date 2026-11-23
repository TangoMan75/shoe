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

src_file="../../../src/shell/strings/_sanitize.sh"

source "${src_file}"

#--------------------------------------------------

test_sanitize_should_escape_backticks() {
    assert_equals 'echo \`date\`' "$(_sanitize 'echo `date`')"
}

test_sanitize_should_escape_multiple_backticks() {
    assert_equals '\`a\` and \`b\`' "$(_sanitize '`a` and `b`')"
}

test_sanitize_should_leave_string_without_backticks_unchanged() {
    assert_equals 'hello world' "$(_sanitize 'hello world')"
}

test_sanitize_should_return_empty_string_for_empty_input() {
    assert_equals '' "$(_sanitize '')"
}

test_sanitize_should_escape_dollar_signs() {
    assert_equals 'echo \$(date)' "$(_sanitize 'echo $(date)')"
}

test_sanitize_should_escape_double_quotes() {
    assert_equals 'say \"hello\"' "$(_sanitize 'say "hello"')"
}

test_sanitize_should_escape_backslashes_once() {
    assert_equals 'C:\\temp' "$(_sanitize 'C:\temp')"
}

test_sanitize_should_replace_newlines_with_spaces() {
    assert_equals 'first second' "$(_sanitize "$(printf 'first\nsecond')")"
}

test_sanitize_should_keep_a_command_substitution_inert_when_evaluated() {
    __tmp__="$(mktemp -d)"
    __marker__="${__tmp__}/injected"
    __value__="\$(touch ${__marker__})\`touch ${__marker__}\`"

    __output__="$(eval "printf '%s' \"$(_sanitize "${__value__}")\"")"

    assert "[ ! -e '${__marker__}' ]"
    assert_equals "${__value__}" "${__output__}"

    rm -rf "${__tmp__}"
}
