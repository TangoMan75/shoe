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

source "../../../src/shell/symfony/_composer_install.sh"
source "../../../src/shell/symfony/_composer_update.sh"
source "../../../src/shell/symfony/_db_create.sh"
source "../../../src/shell/symfony/_db_drop.sh"
source "../../../src/shell/symfony/_db_query.sh"
source "../../../src/shell/symfony/_db_schema.sh"
source "../../../src/shell/symfony/_sf_cache.sh"
source "../../../src/shell/symfony/_sf_lint.sh"
source "../../../src/shell/symfony/_sf_security.sh"
source "../../../src/shell/symfony/_sf_serve.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_check_installed() { return 0; }
_console() { printf 'console'; }
_echo_error() { printf '%b' "$1"; }
_echo_info() { :; }
_is_installed() { return 0; }
_pwd() { printf '/project'; }
composer() { printf 'composer %s\n' "$*"; }
console() { printf 'console %s\n' "$*"; }
find() { :; }
symfony() { printf 'symfony %s\n' "$*"; }

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "bash ../../../src/shell/symfony/_db_create.sh"
}

#--------------------------------------------------
# Composer
#--------------------------------------------------

test_composer_install_should_install_dependencies() {
    assert_equals \
        'composer install --no-interaction --prefer-dist --optimize-autoloader --working-dir=/project' \
        "$(_composer_install)"
}

test_composer_update_should_update_dependencies() {
    assert_equals 'composer update --with-dependencies' "$(_composer_update)"
}

#--------------------------------------------------
# Database
#--------------------------------------------------

test_db_create_should_create_database() {
    assert_equals 'console doctrine:database:create --env dev' "$(_db_create 'dev')"
}

test_db_drop_should_drop_database() {
    assert_equals 'console doctrine:database:drop --force --env test' "$(_db_drop 'test')"
}

test_db_query_should_execute_sql() {
    assert_equals 'console doctrine:query:sql SELECT 1' "$(_db_query 'SELECT 1')"
}

test_db_schema_should_create_schema() {
    assert_equals \
        "console doctrine:schema:create --dump-sql --env dev
console doctrine:schema:create --env dev" \
        "$(_db_schema 'dev')"
}

test_db_create_fails_with_missing_argument() {
    assert_fails "_db_create"
    assert_equals '_db_create: some mandatory parameter is missing' "$(_db_create 2>&1)"
}

test_db_drop_fails_with_missing_argument() {
    assert_fails "_db_drop"
    assert_equals '_db_drop: some mandatory parameter is missing' "$(_db_drop 2>&1)"
}

test_db_query_fails_with_missing_argument() {
    assert_fails "_db_query"
    assert_equals '_db_query: some mandatory parameter is missing' "$(_db_query 2>&1)"
}

test_db_schema_fails_with_missing_argument() {
    assert_fails "_db_schema"
    assert_equals '_db_create: some mandatory parameter is missing' "$(_db_schema 2>&1)"
}

test_db_create_fails_with_too_many_arguments() {
    assert_fails "_db_create 'a' 'b'"
    assert_equals '_db_create: too many arguments (2)' "$(_db_create 'a' 'b' 2>&1)"
}

#--------------------------------------------------
# Cache
#--------------------------------------------------

test_sf_cache_should_clear_and_warmup_cache() {
    assert_equals \
        "console cache:clear --env prod
console cache:warmup --env prod" \
        "$(_sf_cache 'prod')"
}

test_sf_cache_fails_with_missing_argument() {
    assert_fails "_sf_cache"
    assert_equals '_sf_cache: some mandatory parameter is missing' "$(_sf_cache 2>&1)"
}

#--------------------------------------------------
# Lint
#--------------------------------------------------

test_sf_lint_should_run_all_linters() {
    assert_equals \
        "composer validate
console lint:container
console lint:twig ./templates --show-deprecations
console lint:yaml ./compose.yaml ./compose.*.yaml" \
        "$(_sf_lint)"
}

#--------------------------------------------------
# Security
#--------------------------------------------------

test_sf_security_should_use_symfony_when_installed() {
    _is_installed() { return 0; }

    assert_equals 'symfony security:check' "$(_sf_security)"
}

test_sf_security_should_fallback_to_composer_audit() {
    _is_installed() {
        [ "$1" = 'composer' ]
    }

    assert_equals 'composer audit' "$(_sf_security)"
}

test_sf_security_fails_when_no_tool_is_available() {
    _is_installed() { return 1; }

    assert_fails "_sf_security"
    assert_equals "\"${0}\" requires symfony or composer." "$(_sf_security 2>&1)"
}

#--------------------------------------------------
# Serve
#--------------------------------------------------

test_sf_serve_should_start_local_server() {
    assert_equals 'symfony local:server:start --no-tls' "$(_sf_serve)"
}
