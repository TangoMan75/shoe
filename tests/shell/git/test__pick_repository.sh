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

source "../../../src/shell/git/_list_github.sh"
source "../../../src/shell/git/_pick_repository.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_danger() { printf '%b' "$1"; }
_echo_error() { printf '%b' "$1"; }
_echo_info() { printf '%b' "$1"; }
_echo_primary() { printf '%s' "$1"; }
_echo_success() { printf '%s' "$1"; }
_echo_warning() { printf '%s' "$1"; }


#--------------------------------------------------

test_pick_repository_display_help_when_help_flag_is_used() {
    assert "printf '%s' \"$(_pick_repository -h)\" | grep -q 'Select a repository among multiple options'"
}

test_pick_repository_fails_without_owner() {
    assert_fails "_pick_repository"
    assert "printf '%s' \"$(_pick_repository)\" | grep -q 'some mandatory parameter is missing'"
}

test_pick_repository_fails_with_too_many_arguments() {
    assert_fails "_pick_repository 'a' 'b'"
    assert "printf '%s' \"$(_pick_repository 'a' 'b')\" | grep -q 'too many arguments'"
}
