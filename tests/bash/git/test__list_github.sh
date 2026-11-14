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

source "../../../src/bash/git/_list_github.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_danger() { printf '%b' "$1"; }
_echo_info() { printf '%b' "$1"; }
_echo_primary() { printf '%s' "$1"; }
_echo_success() { printf '%s' "$1"; }
_echo_warning() { printf '%s' "$1"; }

LBOUND=0

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __old_path__="${PATH}"
    __stub_dir__="$(mktemp -d)"

    cat > "${__stub_dir__}/curl" <<'STUB'
#!/bin/sh
printf '%s\n' 'https://github.com/example/repository'
STUB
    chmod +x "${__stub_dir__}/curl"

    cat > "${__stub_dir__}/jq" <<'STUB'
#!/bin/sh
cat
STUB
    chmod +x "${__stub_dir__}/jq"

    PATH="${__stub_dir__}:${__old_path__}"
}

teardown() {
    PATH="${__old_path__}"
    rm -rf "${__stub_dir__}"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "bash ../../../src/bash/git/_list_github.sh"
}

#--------------------------------------------------

test_list_github_should_list_repositories() {
    assert_equals \
        'https://github.com/example/repository' \
        "$(_list_github 'example')"
}

test_list_github_should_print_command_when_verbose() {
    assert_equals \
        "curl -s \"https://api.github.com/users/example/repos\" | jq -r '.[].html_url'
https://github.com/example/repository" \
        "$(_list_github -v 'example')"
}

test_list_github_fails_without_owner() {
    assert_fails "_list_github"
    assert "printf '%s' \"$(_list_github)\" | grep -q 'some mandatory parameter is missing'"
}

test_list_github_fails_with_too_many_arguments() {
    assert_fails "_list_github 'a' 'b'"
    assert "printf '%s' \"$(_list_github 'a' 'b')\" | grep -q 'too many arguments'"
}

test_list_github_fails_when_curl_is_missing() {
    rm -f "${__stub_dir__}/curl"
    PATH="${__stub_dir__}"
    __status__=0
    __output__="$(_list_github 'example' 2>&1)" || __status__=$?
    PATH="${__old_path__}"

    assert_equals 1 "${__status__}"
    assert_equals \
        'error: curl required, enter: "sudo apt-get install -y curl" to install' \
        "${__output__}"
}

test_list_github_fails_when_jq_is_missing() {
    rm -f "${__stub_dir__}/jq"
    PATH="${__stub_dir__}"
    __status__=0
    __output__="$(_list_github 'example' 2>&1)" || __status__=$?
    PATH="${__old_path__}"

    assert_equals 1 "${__status__}"
    assert_equals \
        'error: jq required, enter: "sudo apt-get install -y jq" to install' \
        "${__output__}"
}
