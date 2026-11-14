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

source "../../../src/shell/install/_copy_install.sh"
source "../../../src/shell/install/_generate_autocomplete.sh"
source "../../../src/shell/install/_generate_global_autocomplete.sh"
source "../../../src/shell/install/_get_comspec.sh"
source "../../../src/shell/install/_symlink_install.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%b' "$1"; }
_echo_info() { :; }
sudo() { printf 'sudo %s\n' "$*"; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __stub_dir__="$(mktemp -d)"
    __script__="${__stub_dir__}/myscript.sh"
    printf '#!/bin/sh\n' > "${__script__}"
    chmod +x "${__script__}"
}

teardown() {
    rm -rf "${__stub_dir__}"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "bash ../../../src/shell/install/_copy_install.sh"
}

#--------------------------------------------------
# Copy / symlink
#--------------------------------------------------

test_copy_install_should_copy_script_with_default_alias() {
    assert_equals \
        "sudo cp --archive $(realpath "${__script__}") /usr/local/bin/myscript" \
        "$(_copy_install "${__script__}")"
}

test_copy_install_should_copy_script_with_given_alias() {
    assert_equals \
        "sudo cp --archive $(realpath "${__script__}") /usr/local/bin/my-alias" \
        "$(_copy_install "${__script__}" 'my-alias')"
}

test_copy_install_fails_with_missing_argument() {
    assert_fails "_copy_install"
    assert_equals '_copy_install: some mandatory parameter is missing' "$(_copy_install 2>&1)"
}

test_copy_install_fails_with_nonexistent_file() {
    assert_fails "_copy_install 'nonexistent.sh'"
}

test_copy_install_fails_with_too_many_arguments() {
    assert_fails "_copy_install 'a' 'b' 'c'"
    assert_equals '_copy_install: too many arguments (3)' "$(_copy_install 'a' 'b' 'c' 2>&1)"
}

test_symlink_install_should_symlink_script_with_default_alias() {
    assert_equals \
        "sudo ln -s $(realpath "${__script__}") /usr/local/bin/myscript" \
        "$(_symlink_install "${__script__}")"
}

test_symlink_install_should_symlink_script_with_given_alias() {
    assert_equals \
        "sudo ln -s $(realpath "${__script__}") /usr/local/bin/my-alias" \
        "$(_symlink_install "${__script__}" 'my-alias')"
}

test_symlink_install_fails_with_missing_argument() {
    assert_fails "_symlink_install"
    assert_equals '_symlink_install some mandatory parameter is missing' "$(_symlink_install 2>&1)"
}

test_symlink_install_fails_with_nonexistent_file() {
    assert_fails "_symlink_install 'nonexistent.sh'"
}

test_symlink_install_fails_with_too_many_arguments() {
    assert_fails "_symlink_install 'a' 'b' 'c'"
    assert_equals '_symlink_install too many arguments (3)' "$(_symlink_install 'a' 'b' 'c' 2>&1)"
}

#--------------------------------------------------
# Comspec
#--------------------------------------------------

test_get_comspec_should_return_public_commands_and_options() {
    __fixture__="$(realpath '../../../tests/fixtures/documentation_test.sh')"

    assert_equals 'public_command --public_option --public_flag ' "$(_get_comspec "${__fixture__}")"
}

test_get_comspec_fails_with_missing_argument() {
    assert_fails "_get_comspec"
    assert_equals '_get_comspec: some mandatory parameter is missing' "$(_get_comspec 2>&1)"
}

test_get_comspec_fails_with_nonexistent_file() {
    assert_fails "_get_comspec 'nonexistent.sh'"
}

test_get_comspec_fails_with_too_many_arguments() {
    assert_fails "_get_comspec 'a' 'b'"
    assert_equals '_get_comspec: too many arguments (2)' "$(_get_comspec 'a' 'b' 2>&1)"
}

#--------------------------------------------------
# Autocomplete
#--------------------------------------------------

test_generate_autocomplete_should_create_completion_file() {
    _get_comspec() { printf 'public_command '; }

    _generate_autocomplete "${__script__}" 'my-alias'

    assert_equals \
        '#!/bin/bash
complete -f -d -W "public_command " "my-alias"' \
        "$(cat "${__stub_dir__}/my-alias-completion.sh")"
}

test_generate_autocomplete_should_use_default_alias() {
    _get_comspec() { printf 'public_command '; }

    _generate_autocomplete "${__script__}"

    assert "[ -f '${__stub_dir__}/myscript-completion.sh' ]"
}

test_generate_autocomplete_fails_with_missing_argument() {
    assert_fails "_generate_autocomplete"
    assert_equals '_generate_autocomplete: some mandatory parameter is missing' "$(_generate_autocomplete 2>&1)"
}

test_generate_autocomplete_fails_with_nonexistent_file() {
    assert_fails "_generate_autocomplete 'nonexistent.sh'"
}

test_generate_autocomplete_fails_with_too_many_arguments() {
    assert_fails "_generate_autocomplete 'a' 'b' 'c'"
    assert_equals '_generate_autocomplete: too many arguments (3)' "$(_generate_autocomplete 'a' 'b' 'c' 2>&1)"
}

test_generate_global_autocomplete_should_create_system_completion_file() {
    _get_comspec() { printf 'public_command '; }
    __tee_target__="${__stub_dir__}/global-completion.sh"
    sudo() { cat > "${__tee_target__}"; }

    _generate_global_autocomplete "${__script__}" 'my-alias'

    assert_equals \
        '#!/bin/bash
complete -W "public_command " "my-alias"' \
        "$(cat "${__tee_target__}")"
}

test_generate_global_autocomplete_fails_with_missing_argument() {
    assert_fails "_generate_global_autocomplete"
    assert_equals '_generate_global_autocomplete: some mandatory parameter is missing' "$(_generate_global_autocomplete 2>&1)"
}

test_generate_global_autocomplete_fails_with_nonexistent_file() {
    assert_fails "_generate_global_autocomplete 'nonexistent.sh'"
}

test_generate_global_autocomplete_fails_with_too_many_arguments() {
    assert_fails "_generate_global_autocomplete 'a' 'b' 'c'"
    assert_equals '_generate_global_autocomplete: too many arguments (3)' "$(_generate_global_autocomplete 'a' 'b' 'c' 2>&1)"
}
