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

source "../../../src/shell/docker/_docker_compose_start.sh"
source "../../../src/shell/docker/_docker_compose.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%b' "$1"; }
_echo_info() { :; }
_docker_compose() { printf 'docker compose'; }
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
    assert_status_code 0 "bash ../../../src/shell/docker/_docker_compose_start.sh"
}

#--------------------------------------------------
# Compose start
#--------------------------------------------------

test_docker_compose_start_should_start_without_file() {
    assert_equals 'compose up --detach --remove-orphans' "$(_docker_compose_start)"
}

test_docker_compose_start_should_start_with_compose_file() {
    __compose__="${__stub_dir__}/compose.yaml"
    printf 'services: {}\n' > "${__compose__}"

    assert_equals \
        "compose --file $(realpath "${__compose__}") up --detach --remove-orphans" \
        "$(_docker_compose_start "${__compose__}")"
}

test_docker_compose_start_should_start_with_compose_and_env_files() {
    __compose__="${__stub_dir__}/compose.yaml"
    __env__="${__stub_dir__}/.env"
    printf 'services: {}\n' > "${__compose__}"
    printf 'APP_ENV=dev\n' > "${__env__}"

    assert_equals \
        "compose --file $(realpath "${__compose__}") --env-file $(realpath "${__env__}") up --detach --remove-orphans" \
        "$(_docker_compose_start "${__compose__}" "${__env__}")"
}

test_docker_compose_start_fails_with_nonexistent_compose_file() {
    assert_fails "_docker_compose_start 'nonexistent.yaml'"
}

test_docker_compose_start_fails_with_nonexistent_env_file() {
    __compose__="${__stub_dir__}/compose.yaml"
    printf 'services: {}\n' > "${__compose__}"

    assert_fails "_docker_compose_start '${__compose__}' 'nonexistent.env'"
}

test_docker_compose_start_fails_with_too_many_arguments() {
    assert_fails "_docker_compose_start 'a' 'b' 'c'"
    assert_equals "_docker_compose_start: too many arguments (3)" "$(_docker_compose_start 'a' 'b' 'c' 2>&1)"
}
