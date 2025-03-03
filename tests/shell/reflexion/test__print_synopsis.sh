#!/bin/bash

#/*
# * This file is part of TangoMan Shoe package.
# *
# * Copyright (c) 2025 "Matthias Morin" <mat@tangoman.io>
# *
# * This source file is subject to the MIT license that is bundled
# * with this source code in the file LICENSE.
# */

# https://github.com/pgrange/bash_unit
#
#     assert "test -e /tmp/the_file"
#     assert_fails "grep this /tmp/the_file" "should not write 'this' in /tmp/the_file"
#     assert_status_code 25 code # 127: command not found; 126: command not executable
#     assert_equals "a string" "another string" "a string should be another string"
#     assert_not_equals "a string" "a string" "a string should be different from another string"
#     fake ps echo hello world

src_file="../../../src/shell/reflexion/_print_synopsis.sh"

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------

source "${src_file}"

actual='{
    "name": "_foobar",
    "summary": "A function to test _print_synopsis.",
    "scope": "private",
    "namespace": "reflexion",
    "requires": [
        "baz",
        "foobar"
    ],
    "depends": [
        "echo_danger",
        "echo_info"
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
    Depends: echo_danger, echo_info'

test_should_return_expected_string() {
    assert_equals "${expected}" "$(_print_synopsis "${actual}")"
}

# #--------------------------------------------------

expected_markdown='> Synopsis:
> _foobar &lt;FOO&gt; [BAR]
- `FOO`: _(type: "str")_ The input string containing foo.
- `BAR`: _(type: "bool")_ (optional) If set to "true", returns bar. _Defaults to "false"._

- ⚠️ Requires: `baz`, `foobar`
- 🔗 Depends: `echo_danger`, `echo_info`'

test_should_return_expected_markdown_string() {
    assert_equals "${expected_markdown}" "$(_print_synopsis "${actual}" true)"
}
