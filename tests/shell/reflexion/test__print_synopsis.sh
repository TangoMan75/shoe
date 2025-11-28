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

# https://github.com/pgrange/bash_unit
#
#     assert "test -e /tmp/the_file"
#     assert_fails "grep this /tmp/the_file" "should not write 'this' in /tmp/the_file"
#     assert_status_code 25 code # 127: command not found; 126: command not executable
#     assert_equals "a string" "another string" "a string should be another string"
#     assert_not_equals "a string" "a string" "a string should be different from another string"
#     fake ps echo hello world

src_file="../../../src/shell/reflexion/_print_synopsis.sh"

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { echo "$1" ; }

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------

test_print_synopsis_fails_with_missing_arguments() {
    assert_fails "$(_print_synopsis)"
    assert_equals "_print_synopsis: some mandatory parameter is missing\n" "$(_print_synopsis)"
}

fixture='{
    "name": "_foobar",
    "summary": "A function to test _print_synopsis.",
    "scope": "private",
    "namespace": "reflexion",
    "requires": [
        "baz",
        "foobar"
    ],
    "depends": [
        "_echo_danger",
        "_echo_info"
    ],
    "parameters": [
        {
            "position": 1,
            "name": "FOO",
            "type": "str",
            "description": "The input string containing foo.",
            "nullable": false
        },
        {
            "position": 2,
            "name": "BAR",
            "type": "bool",
            "description": "If set to \"true\", returns bar.",
            "default": false
        }
    ]
}'

expected='Synopsis: _foobar (private) <FOO> [BAR]
    FOO: (str) The input string containing foo.
    BAR: (bool) (optional) If set to "true", returns bar. Defaults to "false".
    Requires: baz, foobar
    Depends: _echo_danger, _echo_info'

test_should_return_expected_string() {
    assert_equals "${expected}" "$(_print_synopsis "${fixture}")"
}

#--------------------------------------------------

expected_markdown='> Synopsis:
> _foobar &lt;FOO&gt; [BAR]
- `FOO`: _(type: "str")_ The input string containing foo.
- `BAR`: _(type: "bool")_ (optional) If set to "true", returns bar. _Defaults to "false"._

- ⚠️ Requires: `baz`, `foobar`
- 🔗 Depends: `_echo_danger`, `_echo_info`'

test_should_return_expected_markdown_string() {
    assert_equals "${expected_markdown}" "$(_print_synopsis "${fixture}" true)"
}
