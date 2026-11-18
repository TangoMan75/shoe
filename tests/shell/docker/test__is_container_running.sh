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

source "../../../src/shell/docker/_is_container_running.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_check_installed() { return 0; }
_echo_error() { printf '%b' "$1"; }
_echo_info() { :; }

docker() {
    case "$*" in
        'ps --quiet --format {{.Names}}') printf 'id1\nid2\n' ;;
        'ps --all --quiet') printf 'id1\nid2\n' ;;
        'inspect --format {{slice .Name 1}} id1 id2') printf '%s\n' "${__container_name__:-my-container}" ;;
        'inspect abc123 --format={{.Id}}'|'inspect abc123 --format={{truncate .Id 13}}') printf '%s\n' "${__container_id__:-abcdef012345}" ;;
        'inspect'*'truncate .ID 13'*) printf 'inspect-output\n' ;;
        'inspect'*'State.Running'*) printf '%s\n' "${__running__:-true}" ;;
        'inspect'*'IPAddress'*) printf '%s\n' "${__ip__-10.0.0.2}" ;;
        'inspect'*'slice .Name 1'*) printf '%s\n' "${__container_name__:-my-container}" ;;
        'inspect'*) printf 'inspect-output' ;;
        *) printf '%s\n' "$*" ;;
    esac
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "bash ../../../src/shell/docker/_is_container_running.sh"
}

#--------------------------------------------------
# Is running
#--------------------------------------------------

test_is_container_running_returns_true_when_running() {
    __running__='true'

    assert "_is_container_running 'my-container'"
}

test_is_container_running_returns_false_when_not_running() {
    __running__='false'

    assert_fails "_is_container_running 'my-container'"
}

test_is_container_running_fails_with_missing_argument() {
    assert_fails "_is_container_running"
    assert_equals "_is_container_running: some mandatory parameter is missing" "$(_is_container_running 2>&1)"
}
