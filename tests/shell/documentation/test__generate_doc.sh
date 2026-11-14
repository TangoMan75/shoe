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

src_file="../../../src/shell/documentation/_generate_doc.sh"
colors_dir="../../../src/shell/colors"
reflexion_dir="../../../src/shell/reflexion"
shoedoc_dir="../../../src/shell/shoedoc"

source "${colors_dir}/constants_echo_colors.sh"
source "${colors_dir}/constants_alert_colors.sh"
for __file__ in "${colors_dir}"/_echo_*.sh "${colors_dir}"/_alert_*.sh; do
    source "${__file__}"
done
unset __file__

for __file__ in "${reflexion_dir}"/*.sh "${shoedoc_dir}"/*.sh; do
    source "${__file__}"
done
unset __file__

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_alert_primary() { :; }
_echo_error() { printf '%b' "$1"; }
_echo_info() { :; }
_echo_success() { :; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __destination__="$(mktemp -d)"
    __fixture__="$(realpath '../../../tests/fixtures/documentation_test.sh')"
}

teardown() {
    rm -rf "${__destination__}"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "bash ${src_file}"
}

#--------------------------------------------------

test_generate_doc_should_create_markdown_file() {
    _generate_doc "${__fixture__}" "${__destination__}" 'output.md'

    assert "[ -f '${__destination__}/output.md' ]"
}

test_generate_doc_should_write_script_title_and_description() {
    _generate_doc "${__fixture__}" "${__destination__}" 'output.md'

    assert "grep -q 'TangoMan Documentation Fixture' '${__destination__}/output.md'"
    assert "grep -q '## 📑 Description' '${__destination__}/output.md'"
    assert "grep -q 'Example script for testing documentation generation.' '${__destination__}/output.md'"
}

test_generate_doc_should_document_public_functions_only_by_default() {
    _generate_doc "${__fixture__}" "${__destination__}" 'output.md'

    assert "grep -q '\`public_command\`' '${__destination__}/output.md'"
    assert_fails "grep -q '\`_private_command\`' '${__destination__}/output.md'"
}

test_generate_doc_should_document_private_functions_when_requested() {
    _generate_doc "${__fixture__}" "${__destination__}" 'output.md' 'true'

    assert "grep -q '\`_private_command\`' '${__destination__}/output.md'"
}

test_generate_doc_should_use_default_output_file_name() {
    _generate_doc "${__fixture__}" "${__destination__}"

    assert "[ -f '${__destination__}/documentation_test.md' ]"
}

test_generate_doc_fails_with_missing_argument() {
    assert_fails "_generate_doc"
    assert_equals '_generate_doc: some mandatory parameter is missing' "$(_generate_doc 2>&1)"
}

test_generate_doc_fails_with_too_many_arguments() {
    assert_fails "_generate_doc 'a' 'b' 'c' 'd' 'e'"
    assert_equals '_generate_doc: too many arguments (5)' "$(_generate_doc 'a' 'b' 'c' 'd' 'e' 2>&1)"
}

test_generate_doc_fails_with_nonexistent_file() {
    assert_fails "_generate_doc 'nonexistent.sh'"
}

test_generate_doc_fails_with_non_shell_file() {
    __file__="${__destination__}/file.txt"
    touch "${__file__}"

    assert_fails "_generate_doc '${__file__}' '${__destination__}'"
    assert_equals '_generate_doc: file should be type ".sh"' "$(_generate_doc "${__file__}" "${__destination__}" 2>&1)"
}

test_generate_doc_fails_with_nonexistent_destination() {
    assert_fails "_generate_doc '${__fixture__}' 'nonexistent'"
}
