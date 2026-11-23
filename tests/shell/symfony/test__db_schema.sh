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

src_file="../../../src/shell/symfony/_db_schema.sh"

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_console() { printf 'console'; }
_echo_error() { printf '%b' "$1"; }
_echo_info() { :; }
console() { printf 'console %s\n' "$*"; }

#--------------------------------------------------
# Database
#--------------------------------------------------

test_db_schema_should_create_schema() {
    assert_equals \
        "console doctrine:schema:create --dump-sql --env dev
console doctrine:schema:create --env dev" \
        "$(_db_schema 'dev')"
}

test_db_schema_fails_with_missing_argument() {
    assert_fails "_db_schema"
    assert_equals '_db_create: some mandatory parameter is missing' "$(_db_schema 2>&1)"
}
