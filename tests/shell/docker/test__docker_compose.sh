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

compose_src="../../../src/shell/docker/_get_docker_compose.sh"

source "../../../src/shell/docker/_docker_compose_build.sh"
source "../../../src/shell/docker/_docker_compose_start.sh"
source "../../../src/shell/docker/_docker_compose_stop.sh"
source "${compose_src}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_check_installed() { return 0; }
_echo_error() { printf '%b' "$1"; }
_echo_info() { :; }
_get_docker_compose() { printf 'docker compose'; }
docker() { printf '%s\n' "$*"; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __old_path__="${PATH}"
    __stub_dir__="$(mktemp -d)"
    __bin_dir__="${__stub_dir__}/bin"
    mkdir -p "${__bin_dir__}"
    ln -s "$(command -v basename)" "${__bin_dir__}/basename"

    printf '#!/bin/sh\nexit 0\n' > "${__stub_dir__}/docker-compose"
    chmod +x "${__stub_dir__}/docker-compose"
}

teardown() {
    PATH="${__old_path__}"
    rm -rf "${__stub_dir__}"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "bash ../../../src/shell/docker/_docker_compose_build.sh"
}

#--------------------------------------------------
# Compose build
#--------------------------------------------------

test_docker_compose_build_should_build_without_file() {
    assert_equals 'compose build' "$(_docker_compose_build)"
}

test_docker_compose_build_should_build_with_given_file() {
    __file__="${__stub_dir__}/compose.yaml"
    printf 'services: {}\n' > "${__file__}"

    assert_equals "compose --file $(realpath "${__file__}") build" "$(_docker_compose_build "${__file__}")"
}

test_docker_compose_build_fails_with_nonexistent_file() {
    assert_fails "_docker_compose_build 'nonexistent.yaml'"
}

test_docker_compose_build_fails_with_too_many_arguments() {
    assert_fails "_docker_compose_build 'a' 'b'"
    assert_equals "_docker_compose_build: too many arguments (2)" "$(_docker_compose_build 'a' 'b' 2>&1)"
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

#--------------------------------------------------
# Compose stop
#--------------------------------------------------

test_docker_compose_stop_should_stop_without_file() {
    assert_equals 'compose stop' "$(_docker_compose_stop)"
}

test_docker_compose_stop_should_stop_with_given_file() {
    __file__="${__stub_dir__}/compose.yaml"
    printf 'services: {}\n' > "${__file__}"

    assert_equals "compose --file $(realpath "${__file__}") stop" "$(_docker_compose_stop "${__file__}")"
}

test_docker_compose_stop_fails_with_nonexistent_file() {
    assert_fails "_docker_compose_stop 'nonexistent.yaml'"
}

test_docker_compose_stop_fails_with_too_many_arguments() {
    assert_fails "_docker_compose_stop 'a' 'b'"
    assert_equals "_docker_compose_stop: too many arguments (2)" "$(_docker_compose_stop 'a' 'b' 2>&1)"
}

#--------------------------------------------------
# Get docker compose
#--------------------------------------------------

test_get_docker_compose_returns_plugin_when_available() {
    docker() { printf 'usage\n'; return 0; }
    unset -f _get_docker_compose
    source "${compose_src}"

    assert_equals 'docker compose' "$(_get_docker_compose)"
}

test_get_docker_compose_returns_standalone_binary_as_fallback() {
    docker() { return 1; }
    unset -f _get_docker_compose
    source "${compose_src}"
    PATH="${__stub_dir__}:${__old_path__}"

    assert_equals 'docker-compose' "$(_get_docker_compose)"
}

test_get_docker_compose_exits_when_no_compose_is_available() {
    docker() { return 1; }
    unset -f _get_docker_compose
    source "${compose_src}"
    PATH="${__bin_dir__}"
    __status__=0
    __output__="$(_get_docker_compose 2>&1)" || __status__=$?
    PATH="${__old_path__}"

    assert_equals 1 "${__status__}"
    assert_equals '"bash_unit" requires docker-compose or docker compose plugin' "${__output__}"
}
