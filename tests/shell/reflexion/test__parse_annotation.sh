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

src_file="../../../src/shell/reflexion/_parse_annotation.sh"

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------

source ../../../src/shell/reflexion/_get_function_annotation.sh
source "${src_file}"

expected='{
  "name": "_parse_annotation",
  "summary": "Return function annotation as json",
  "scope": "private",
  "namespace": "reflexion",
  "requires": [
    "jq",
    "sed"
  ],
  "depends": [
    "_get_function_annotation",
    "echo_danger"
  ],
  "parameters": [
    {
      "position": 1,
      "name": "SCRIPT_PATH",
      "type": "file",
      "description": "The path to the input script.",
      "nullable": false
    },
    {
      "position": 2,
      "name": "FUNCTION_NAME",
      "type": "str",
      "description": "The name of the function to retrieve.",
      "nullable": false
    }
  ]
}'

test_should_return_expected_json() {
    assert_equals "${expected}" "$(_parse_annotation "${src_file}" "_parse_annotation")"
}

