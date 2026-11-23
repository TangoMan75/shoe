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

src_file="../../../src/shell/strings/_url_encode.sh"
decode_src="../../../src/shell/strings/_url_decode.sh"

source "${src_file}"
source "${decode_src}"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%s' "$1"; }

#--------------------------------------------------

test_url_encode_should_encode_reserved_characters() {
    assert_equals 'Hello%20World%21' "$(_url_encode 'Hello World!')"
    assert_equals 'a%2Bb%2Fc%3Fd%3De%26f' "$(_url_encode 'a+b/c?d=e&f')"
}

test_url_encode_should_keep_unreserved_characters() {
    assert_equals 'azAZ09-_.~' "$(_url_encode 'azAZ09-_.~')"
}

test_url_codec_should_roundtrip() {
    assert_equals 'a+b c/d?e=f&g' "$(_url_decode "$(_url_encode 'a+b c/d?e=f&g')")"
}

test_url_encode_fails_with_missing_argument() {
    assert_fails "_url_encode"
    assert_equals '_url_encode: some mandatory parameter is missing\n' "$(_url_encode 2>&1)"
}
