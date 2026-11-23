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

source "../../../src/shell/ssh/_ssh_add_all_identities.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_error() { printf '%s' "$1"; }
_echo_info() { printf '%b' "$1"; }
_echo_warning() { printf '%b' "$1"; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __old_path__="${PATH}"
    __old_home__="${HOME}"
    __tmp_dir__="$(mktemp -d)"
}

teardown() {
    PATH="${__old_path__}"
    HOME="${__old_home__}"
    rm -rf "${__tmp_dir__}"
}

#--------------------------------------------------
# Add all identities
#--------------------------------------------------

test_ssh_add_all_identities_should_add_matching_private_keys() {
    cat > "${__tmp_dir__}/ssh-add" <<'STUB'
#!/bin/sh
printf 'ssh-add %s\n' "$*"
STUB
    chmod +x "${__tmp_dir__}/ssh-add"
    PATH="${__tmp_dir__}:${PATH}"

    HOME="${__tmp_dir__}/home"
    mkdir -p "${HOME}/.ssh"
    printf 'private' > "${HOME}/.ssh/id_test"
    printf 'public' > "${HOME}/.ssh/id_test.pub"

    assert_equals \
        "ssh-add ${HOME}/.ssh/id_test" \
        "$(_ssh_add_all_identities | tail -n 1)"
}

test_ssh_add_all_identities_should_skip_orphan_public_keys() {
    cat > "${__tmp_dir__}/ssh-add" <<'STUB'
#!/bin/sh
printf 'ssh-add %s\n' "$*"
STUB
    chmod +x "${__tmp_dir__}/ssh-add"
    PATH="${__tmp_dir__}:${PATH}"

    HOME="${__tmp_dir__}/home"
    mkdir -p "${HOME}/.ssh"
    printf 'public' > "${HOME}/.ssh/orphan.pub"

    assert_equals \
        "error: \"${HOME}/.ssh/orphan\" private key not found" \
        "$(_ssh_add_all_identities 2>&1 | head -n 1)"
}
