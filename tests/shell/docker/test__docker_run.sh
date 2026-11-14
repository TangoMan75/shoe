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

source "../../../src/shell/docker/_docker_run.sh"
source "../../../src/shell/docker/_docker_run_atmoz_sftp.sh"
source "../../../src/shell/docker/_docker_run_whoami.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_check_installed() { return 0; }
_echo_error() { printf '%b' "$1"; }
_echo_info() { :; }
docker() { printf '%s\n' "$*"; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __stub_dir__="$(mktemp -d)"
}

teardown() {
    rm -rf "${__stub_dir__}"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "bash ../../../src/shell/docker/_docker_run.sh"
}

#--------------------------------------------------
# Docker run
#--------------------------------------------------

test_docker_run_should_run_container() {
    assert_equals \
        'run --detach --rm --interactive --tty --name my-container alpine echo hi' \
        "$(_docker_run 'alpine' 'my-container' 'echo hi')"
}

test_docker_run_should_mount_volume_when_folder_is_provided() {
    __folder__="${__stub_dir__}/volume"
    mkdir -p "${__folder__}"

    assert_equals \
        "run --detach --rm --interactive --tty --volume=$(realpath "${__folder__}"):/home --workdir=/home --name my-container alpine echo hi" \
        "$(_docker_run 'alpine' 'my-container' 'echo hi' "${__folder__}")"
}

test_docker_run_fails_with_missing_arguments() {
    assert_fails "_docker_run"
    assert_equals "_docker_run: some mandatory parameter is missing" "$(_docker_run 2>&1)"
}

test_docker_run_fails_with_nonexistent_volume() {
    assert_fails "_docker_run 'alpine' 'my-container' 'echo hi' 'nonexistent'"
}

test_docker_run_fails_with_too_many_arguments() {
    assert_fails "_docker_run 'a' 'b' 'c' 'd' 'e'"
    assert_equals "_docker_run: too many arguments (5)" "$(_docker_run 'a' 'b' 'c' 'd' 'e' 2>&1)"
}

#--------------------------------------------------
# Whoami
#--------------------------------------------------

test_docker_run_whoami_should_run_whoami_container() {
    assert_equals \
        'run --detach --publish-all --rm --name whoami traefik/whoami' \
        "$(_docker_run_whoami)"
}

test_docker_run_whoami_fails_with_arguments() {
    assert_fails "_docker_run_whoami 'unexpected'"
    assert_equals "_docker_run_whoami: too many arguments (1)" "$(_docker_run_whoami 'unexpected' 2>&1)"
}

#--------------------------------------------------
# Atmoz sftp
#--------------------------------------------------

test_docker_run_atmoz_sftp_should_run_sftp_container() {
    assert_equals \
        'run --network bridge --publish 22:22 --detach --rm --name atmoz_sftp atmoz/sftp user:pass' \
        "$(_docker_run_atmoz_sftp 'user' 'pass')"
}

test_docker_run_atmoz_sftp_should_use_given_network() {
    assert "printf '%s' \"$(_docker_run_atmoz_sftp 'user' 'pass' 'host')\" | grep -q -- '--network host'"
}

test_docker_run_atmoz_sftp_should_mount_volume_when_folder_is_provided() {
    __folder__="${__stub_dir__}/shared"
    mkdir -p "${__folder__}"
    __volume__="$(realpath "${__folder__}")"

    assert "printf '%s' \"$(_docker_run_atmoz_sftp 'user' 'pass' 'bridge' "${__folder__}")\" | grep -q -- '--volume=${__volume__}:/home/shared'"
}

test_docker_run_atmoz_sftp_fails_with_missing_arguments() {
    assert_fails "_docker_run_atmoz_sftp"
    assert_equals "_docker_run_atmoz_sftp: some mandatory parameter is missing" "$(_docker_run_atmoz_sftp 2>&1)"
}

test_docker_run_atmoz_sftp_fails_with_nonexistent_folder() {
    assert_fails "_docker_run_atmoz_sftp 'user' 'pass' 'bridge' 'nonexistent'"
}

test_docker_run_atmoz_sftp_fails_with_too_many_arguments() {
    assert_fails "_docker_run_atmoz_sftp 'a' 'b' 'c' 'd' 'e'"
    assert_equals "_docker_run_atmoz_sftp: too many arguments (5)" "$(_docker_run_atmoz_sftp 'a' 'b' 'c' 'd' 'e' 2>&1)"
}
