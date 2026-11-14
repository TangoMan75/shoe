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

source "../../../src/shell/docker/_wait_for_postgres.sh"
source "../../../src/shell/docker/_wait_for_rabbit.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_check_installed() { return 0; }
_echo_error() { printf '%b' "$1"; }
_echo_success() { printf '%b' "$1"; }
_echo_warning() { printf '%b' "$1"; }
_spin() { :; }
docker() {
    case "$*" in
        'exec my-postgres psql -l'|'exec my-postgres psql  -l') printf 'databases\n' ;;
        'exec my-postgres psql --username admin -l'|'exec my-postgres psql --username admin  -l') printf 'databases\n' ;;
        'exec my-rabbit rabbitmqctl wait --pid 1 --timeout 1') printf "Applications 'rabbit_and_plugins' are running\n" ;;
        *) return 1 ;;
    esac
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "bash ../../../src/shell/docker/_wait_for_postgres.sh"
}

#--------------------------------------------------
# Postgres
#--------------------------------------------------

test_wait_for_postgres_should_wait_until_database_is_ready() {
    __output__="$(_wait_for_postgres 'my-postgres')"

    assert "printf '%s' \"\${__output__}\" | grep -q 'Waiting for \"my-postgres\" database to start.'"
    assert "printf '%s' \"\${__output__}\" | grep -q '\"my-postgres\" is runnning.'"
}

test_wait_for_postgres_should_use_username_when_provided() {
    __output__="$(_wait_for_postgres 'my-postgres' 'admin')"

    assert "printf '%s' \"\${__output__}\" | grep -q 'is runnning'"
}

test_wait_for_postgres_fails_with_missing_argument() {
    assert_fails "_wait_for_postgres"
    assert_equals "_wait_for_postgres: some mandatory parameter is missing" "$(_wait_for_postgres 2>&1)"
}

test_wait_for_postgres_fails_with_too_many_arguments() {
    assert_fails "_wait_for_postgres 'a' 'b' 'c'"
    assert_equals "_wait_for_postgres: too many arguments (3)" "$(_wait_for_postgres 'a' 'b' 'c' 2>&1)"
}

#--------------------------------------------------
# Rabbit
#--------------------------------------------------

test_wait_for_rabbit_should_wait_until_rabbit_is_ready() {
    __output__="$(_wait_for_rabbit 'my-rabbit')"

    assert "printf '%s' \"\${__output__}\" | grep -q 'Waiting for \"my-rabbit\" to start.'"
    assert "printf '%s' \"\${__output__}\" | grep -q '\"my-rabbit\" is runnning.'"
}

test_wait_for_rabbit_fails_with_missing_argument() {
    assert_fails "_wait_for_rabbit"
    assert_equals "_wait_for_rabbit: some mandatory parameter is missing" "$(_wait_for_rabbit 2>&1)"
}

test_wait_for_rabbit_fails_with_too_many_arguments() {
    assert_fails "_wait_for_rabbit 'a' 'b'"
    assert_equals "_wait_for_rabbit: too many arguments (2)" "$(_wait_for_rabbit 'a' 'b' 2>&1)"
}
