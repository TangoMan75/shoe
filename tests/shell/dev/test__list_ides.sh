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

src_file="../../../src/shell/dev/_list_ides.sh"

source "${src_file}"

#--------------------------------------------------
# Helpers
#--------------------------------------------------

teardown() {
    unset -f command 2>/dev/null || true
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

#--------------------------------------------------

test_list_ides_should_return_nothing_when_no_ide_is_installed() {
    command() {
        if [ "$1" = '-v' ]; then
            return 1
        fi
        builtin command "$@"
    }

    assert_equals '' "$(_list_ides)"
}

test_list_ides_should_list_installed_ides_in_expected_order() {
    command() {
        if [ "$1" = '-v' ]; then
            case "$2" in
                code|nano|vim) printf '%s\n' "$2" ;;
                *) return 1 ;;
            esac
        fi
    }

    assert_equals 'code nano vim ' "$(_list_ides)"
}

test_list_ides_should_detect_all_supported_ides() {
    command() {
        if [ "$1" = '-v' ]; then
            printf '%s\n' "$2"
        fi
    }

    expected='antigravity atom clion code codium cursor intellij-idea-community micro nano nvim phpstorm pycharm pycharm-community subl vim webstorm windsurf zed '
    assert_equals "${expected}" "$(_list_ides)"
}
