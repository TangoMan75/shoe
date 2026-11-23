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

src_file="../../../src/shell/reflexion/_set_parameter.sh"

source "${src_file}"
source ../../../src/shell/reflexion/_get_parameter.sh

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { echo "$1" ; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    tmp_dir="$(mktemp -d)"
    file="${tmp_dir}/.env"
}

teardown() {
    rm -rf "${tmp_dir}"
}

#--------------------------------------------------

test_set_parameter_does_not_change_when_value_unchanged() {
    cp "../../fixtures/parameters.env" "${file}"

    _set_parameter "${file}" "KEY1" "value1"

    assert_equals "value1" "$(_get_parameter "${file}" "KEY1")"
    assert_equals \
        "$(cat "../../fixtures/parameters.env")" \
        "$(cat "${file}")"
}

test_set_parameter_fails_for_nonexistent_key() {
    cp "../../fixtures/parameters.env" "${file}"

    assert_fails "_set_parameter '${file}' NONEXISTENT new_val"
    assert_equals \
        '_set_parameter: "NONEXISTENT" parameter not found\n' \
        "$(_set_parameter "${file}" NONEXISTENT new_val 2>&1)"
    assert_equals \
        "$(cat "../../fixtures/parameters.env")" \
        "$(cat "${file}")"
}

test_set_parameter_fails_with_missing_arguments() {
    assert_fails "_set_parameter"
    assert_equals \
        "_set_parameter: some mandatory parameter is missing\n" \
        "$(_set_parameter)"
}

test_set_parameter_fails_with_missing_value() {
    cp "../../fixtures/parameters.env" "${file}"

    assert_fails "_set_parameter '${file}' KEY1"
    assert_equals \
        "_set_parameter: some mandatory parameter is missing\n" \
        "$(_set_parameter "${file}" KEY1)"
}

test_set_parameter_fails_with_nonexistent_file() {
    assert_fails "_set_parameter nonexistent.env KEY1 new_val"
    assert_equals \
        "_set_parameter: \"nonexistent.env\" file not found\n" \
        "$(_set_parameter nonexistent.env KEY1 new_val)"
}

#--------------------------------------------------
# Set var
#--------------------------------------------------

test_set_parameter_should_update_existing_variable() {
    printf 'FOO=bar\nBAZ=qux\n' > "${file}"

    _set_parameter "${file}" FOO updated

    assert_equals "FOO='updated'" "$(sed -n '1p' "${file}")"
    assert_equals 'BAZ=qux' "$(sed -n '2p' "${file}")"
}

test_set_parameter_should_append_new_variable_with_force() {
    printf 'FOO=bar\n' > "${file}"

    _set_parameter "${file}" NEW value true

    assert_equals 'FOO=bar' "$(sed -n '1p' "${file}")"
    assert_equals "NEW='value'" "$(sed -n '2p' "${file}")"
}

test_set_parameter_should_write_a_value_that_sources_inertly() {
    printf 'FOO=bar\n' > "${file}"

    _set_parameter "${file}" FOO '$(printf injected)'

    # Sourcing the file must store the text literally, not run it.
    assert_equals '$(printf injected)' \
        "$(sh -c ". '${file}'; printf '%s' \"\${FOO}\"")"
}

test_set_parameter_should_escape_embedded_single_quotes() {
    printf 'FOO=bar\n' > "${file}"

    _set_parameter "${file}" FOO "it's"

    assert_equals "FOO='it'\\''s'" "$(sed -n '1p' "${file}")"
    assert_equals "it's" "$(_get_parameter "${file}" FOO)"
    assert_equals "it's" "$(sh -c ". '${file}'; printf '%s' \"\${FOO}\"")"
}

test_set_parameter_should_keep_a_quoted_value_idempotent() {
    printf "FOO='bar'\n" > "${file}"

    _set_parameter "${file}" FOO bar

    assert_equals "FOO='bar'" "$(sed -n '1p' "${file}")"
    assert "test \"\$(wc -l < '${file}')\" -eq 1"
}

test_set_parameter_fails_when_variable_not_found() {
    printf 'FOO=bar\n' > "${file}"

    assert_fails "_set_parameter '${file}' NEW value"
    assert_equals \
        '_set_parameter: "NEW" parameter not found\n' \
        "$(_set_parameter "${file}" NEW value 2>&1)"
    assert_equals 'FOO=bar' "$(sed -n '1p' "${file}")"
    assert "test \"\$(wc -l < '${file}')\" -eq 1"
}

test_set_parameter_should_not_interpret_backslash_escapes() {
    printf 'FOO=bar\n' > "${file}"

    _set_parameter "${file}" FOO 'C:\temp\new'

    assert_equals "FOO='C:\\temp\\new'" "$(sed -n '1p' "${file}")"
    assert "test \"\$(wc -l < '${file}')\" -eq 1"
}

test_set_parameter_fails_with_invalid_parameter_name() {
    printf 'FOO=bar\n' > "${file}"

    assert_fails "_set_parameter '${file}' '1INVALID' value"
    assert_equals \
        '_set_parameter: invalid parameter name "1INVALID"\n' \
        "$(_set_parameter "${file}" '1INVALID' value 2>&1)"
    assert_equals 'FOO=bar' "$(sed -n '1p' "${file}")"
}

test_set_parameter_fails_with_missing_file() {
    assert_fails "_set_parameter '${tmp_dir}/missing' FOO bar"
}

test_set_parameter_updates_an_indented_assignment() {
    printf '  FOO=one\n' > "${file}"

    _set_parameter "${file}" FOO two

    assert_equals "  FOO='two'" "$(cat "${file}")"
}

test_set_parameter_updates_an_exported_assignment() {
    printf 'export FOO=one\n' > "${file}"

    _set_parameter "${file}" FOO two

    assert_equals "export FOO='two'" "$(cat "${file}")"
}
