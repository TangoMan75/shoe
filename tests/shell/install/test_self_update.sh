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

src_file="../../../src/shell/install/self_update.sh"

source "${src_file}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_danger() { printf '%b' "$1"; }
_get_script_shoedoc() { printf 'annotations'; }
_get_shoedoc_tag() { printf '%s' "${__update_link__:-}"; }
_update() { printf 'update:%s:%s:%s:%s\n' "$1" "$2" "$3" "$4"; }

#--------------------------------------------------
# Self update
#--------------------------------------------------

test_self_update_should_update_current_script() {
    _update() { printf 'update:%s:%s:%s:%s\n' "$1" "$2" "$3" "$4"; }
    unset ALIAS global
    __update_link__='https://example.com/myscript.sh'

    assert_equals \
        "update:${0}:https://example.com/myscript.sh:$(basename "${0}" .sh):false" \
        "$(self_update)"
}

test_self_update_fails_without_update_tag() {
    unset ALIAS global
    __update_link__=''

    assert_fails "self_update"
    assert_equals 'cannot update: "@update" missing' "$(self_update 2>&1)"
}
