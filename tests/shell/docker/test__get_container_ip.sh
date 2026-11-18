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

source "../../../src/shell/docker/_get_container_ip.sh"

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
    assert_status_code 0 "bash ../../../src/shell/docker/_get_container_ip.sh"
}

#--------------------------------------------------
# Container id / name / ip
#--------------------------------------------------

test_get_container_ip_should_return_container_ip() {
    __running__='true'
    __ip__='172.17.0.2'

    assert_equals '172.17.0.2' "$(_get_container_ip 'my-container')"
}

test_get_container_ip_fails_when_container_is_not_running() {
    __running__='false'

    assert_fails "_get_container_ip 'my-container'"
}

test_get_container_ip_returns_localhost_when_ip_is_empty() {
    __running__='true'
    __ip__=''

    assert_equals '127.0.0.1' "$(_get_container_ip 'my-container')"
}

test_get_container_ip_fails_with_missing_argument() {
    assert_fails "_get_container_ip"
    assert_equals "_get_container_ip: some mandatory parameter is missing" "$(_get_container_ip 2>&1)"
}
