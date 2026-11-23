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

source "../../../src/shell/system/_get_web_user.sh"

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __old_path__="${PATH}"
    __tmp_dir__="$(mktemp -d)"
}

teardown() {
    PATH="${__old_path__}"
    rm -rf "${__tmp_dir__}"
}

#--------------------------------------------------
# Get web user
#--------------------------------------------------

test_get_web_user_should_return_web_server_user() {
    cat > "${__tmp_dir__}/ps" <<'STUB'
#!/bin/sh
printf 'www-data nginx\nroot systemd\n'
STUB
    chmod +x "${__tmp_dir__}/ps"
    PATH="${__tmp_dir__}:${PATH}"

    assert_equals 'www-data' "$(_get_web_user)"
}

test_get_web_user_should_fallback_to_www_data() {
    cat > "${__tmp_dir__}/ps" <<'STUB'
#!/bin/sh
printf 'root systemd\n'
STUB
    chmod +x "${__tmp_dir__}/ps"
    PATH="${__tmp_dir__}:${PATH}"

    assert_equals 'www-data' "$(_get_web_user)"
}
