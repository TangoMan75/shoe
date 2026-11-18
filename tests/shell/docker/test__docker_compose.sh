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

compose_src="../../../src/shell/docker/_docker_compose.sh"

source "${compose_src}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%b' "$1"; }
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
    assert_status_code 0 "bash ../../../src/shell/docker/_docker_compose.sh"
}

#--------------------------------------------------
# Docker compose
#--------------------------------------------------

test_docker_compose_returns_plugin_when_available() {
    docker() { printf 'usage\n'; return 0; }
    unset -f _docker_compose
    source "${compose_src}"

    assert_equals 'docker compose' "$(_docker_compose)"
}

test_docker_compose_returns_standalone_binary_as_fallback() {
    docker() { return 1; }
    unset -f _docker_compose
    source "${compose_src}"
    PATH="${__stub_dir__}:${__old_path__}"

    assert_equals 'docker-compose' "$(_docker_compose)"
}

test_docker_compose_exits_when_no_compose_is_available() {
    docker() { return 1; }
    unset -f _docker_compose
    source "${compose_src}"
    PATH="${__bin_dir__}"
    __status__=0
    __output__="$(_docker_compose 2>&1)" || __status__=$?
    PATH="${__old_path__}"

    assert_equals 1 "${__status__}"
    assert_equals '"bash_unit" requires docker-compose or docker compose plugin' "${__output__}"
}
