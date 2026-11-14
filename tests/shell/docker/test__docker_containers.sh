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

source "../../../src/shell/docker/_docker_exec.sh"
source "../../../src/shell/docker/_docker_kill_all.sh"
source "../../../src/shell/docker/_docker_rm.sh"
source "../../../src/shell/docker/_docker_status.sh"
source "../../../src/shell/docker/_find_container_name.sh"
source "../../../src/shell/docker/_get_container_id.sh"
source "../../../src/shell/docker/_get_container_ip.sh"
source "../../../src/shell/docker/_get_container_name.sh"
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
    assert_status_code 0 "bash ../../../src/shell/docker/_docker_exec.sh"
}

#--------------------------------------------------
# Exec
#--------------------------------------------------

test_docker_exec_should_execute_command_in_container() {
    assert_equals 'exec --interactive --tty my-container echo hi' "$(_docker_exec 'my-container' 'echo hi')"
}

test_docker_exec_should_execute_command_as_given_user() {
    assert_equals \
        'exec --interactive --tty --user www-data my-container echo hi' \
        "$(_docker_exec 'my-container' 'echo hi' 'www-data')"
}

test_docker_exec_fails_with_missing_arguments() {
    assert_fails "_docker_exec"
    assert_equals "_docker_exec: some mandatory parameter is missing" "$(_docker_exec 2>&1)"
}

test_docker_exec_fails_with_too_many_arguments() {
    assert_fails "_docker_exec 'a' 'b' 'c' 'd'"
    assert_equals "_docker_exec: too many arguments (4)" "$(_docker_exec 'a' 'b' 'c' 'd' 2>&1)"
}

#--------------------------------------------------
# Remove / kill
#--------------------------------------------------

test_docker_rm_should_remove_container() {
    assert_equals 'rm my-container' "$(_docker_rm 'my-container')"
}

test_docker_rm_fails_with_missing_argument() {
    assert_fails "_docker_rm"
    assert_equals "_docker_rm: some mandatory parameter is missing" "$(_docker_rm 2>&1)"
}

test_docker_rm_fails_with_too_many_arguments() {
    assert_fails "_docker_rm 'a' 'b'"
    assert_equals "_docker_rm: too many arguments (2)" "$(_docker_rm 'a' 'b' 2>&1)"
}

test_docker_kill_all_should_kill_all_containers() {
    assert_equals 'kill id1 id2' "$(_docker_kill_all)"
}

#--------------------------------------------------
# Status
#--------------------------------------------------

test_docker_status_should_print_container_infos() {
    assert "printf '%s' \"$(_docker_status)\" | grep -q 'inspect-output'"
}

#--------------------------------------------------
# Find container
#--------------------------------------------------

test_find_container_name_should_return_first_matching_container() {
    assert_equals 'my-container' "$(_find_container_name 'my')"
}

test_find_container_name_fails_with_missing_argument() {
    assert_fails "_find_container_name"
    assert_equals "_find_container_name: some mandatory parameter is missing" "$(_find_container_name 2>&1)"
}

test_find_container_name_fails_with_too_many_arguments() {
    assert_fails "_find_container_name 'a' 'b'"
    assert_equals "_find_container_name: too many arguments (2)" "$(_find_container_name 'a' 'b' 2>&1)"
}

#--------------------------------------------------
# Container id / name / ip
#--------------------------------------------------

test_get_container_id_should_return_truncated_id_by_default() {
    assert_equals 'abcdef012345' "$(_get_container_id 'abc123')"
}

test_get_container_id_should_return_full_id_when_truncate_is_false() {
    __container_id__='abcdef0123456789'
    assert_equals 'abcdef0123456789' "$(_get_container_id 'abc123' 'false')"
}

test_get_container_id_fails_with_missing_argument() {
    assert_fails "_get_container_id"
    assert_equals "_get_container_id: some mandatory parameter is missing" "$(_get_container_id 2>&1)"
}

test_get_container_name_should_return_container_name() {
    assert_equals 'my-container' "$(_get_container_name 'abc123')"
}

test_get_container_name_fails_with_missing_argument() {
    assert_fails "_get_container_name"
    assert_equals "_get_container_name: some mandatory parameter is missing" "$(_get_container_name 2>&1)"
}

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
