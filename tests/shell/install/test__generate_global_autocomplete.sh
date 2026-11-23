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

src_file="../../../src/shell/install/_generate_global_autocomplete.sh"

source "${src_file}"
source "../../../src/shell/validation/_validate_alias.sh"

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
# Autocomplete
#--------------------------------------------------

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
