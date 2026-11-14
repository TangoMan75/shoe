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

source "../../../src/shell/install/_install.sh"
source "../../../src/shell/install/_uninstall.sh"
source "../../../src/shell/install/_update.sh"
source "../../../src/shell/install/self_install.sh"
source "../../../src/shell/install/self_uninstall.sh"
source "../../../src/shell/install/self_update.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

_echo_danger() { printf '%b' "$1"; }
_echo_error() { printf '%b' "$1"; }
_echo_info() { :; }
_echo_success() { :; }
_is_installed() { return 1; }
_copy_install() { printf 'copy:%s:%s\n' "$1" "$2"; }
_generate_autocomplete() { printf 'autocomplete:%s:%s\n' "$1" "$2"; }
_generate_global_autocomplete() { printf 'global-autocomplete:%s:%s\n' "$1" "$2"; }
_set_completion_autoload() { printf 'autoload:%s:%s:%s\n' "$1" "$2" "$3"; }
_symlink_install() { printf 'symlink:%s:%s\n' "$1" "$2"; }
_remove_completion_autoload() { printf 'remove-autoload:%s:%s\n' "$1" "$2"; }
_get_script_shoedoc() { printf 'annotations'; }
_get_shoedoc_tag() { printf '%s' "${__update_link__:-}"; }
sudo() { printf 'sudo %s\n' "$*"; }

#--------------------------------------------------
# Helpers
#--------------------------------------------------

setup() {
    __stub_dir__="$(mktemp -d)"
    __script__="${__stub_dir__}/myscript.sh"
    printf '#!/bin/sh\n' > "${__script__}"
}

teardown() {
    rm -rf "${__stub_dir__}"
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "bash ../../../src/shell/install/_install.sh"
}

#--------------------------------------------------
# Install
#--------------------------------------------------

test_install_should_symlink_script_and_generate_autocomplete() {
    assert_equals \
        "symlink:$(realpath "${__script__}"):myscript
autocomplete:$(realpath "${__script__}"):myscript" \
        "$(_install "${__script__}")"
}

test_install_should_copy_script_and_generate_global_autocomplete() {
    assert_equals \
        "copy:$(realpath "${__script__}"):my-alias
global-autocomplete:$(realpath "${__script__}"):my-alias" \
        "$(_install "${__script__}" 'my-alias' 'true')"
}

test_install_fails_with_missing_argument() {
    assert_fails "_install"
    assert_equals '_install: some mandatory parameter is missing' "$(_install 2>&1)"
}

test_install_fails_with_nonexistent_file() {
    assert_fails "_install 'nonexistent.sh'"
}

test_install_fails_with_too_many_arguments() {
    assert_fails "_install 'a' 'b' 'c' 'd'"
    assert_equals '_install: too many arguments (4)' "$(_install 'a' 'b' 'c' 'd' 2>&1)"
}

#--------------------------------------------------
# Uninstall
#--------------------------------------------------

test_uninstall_should_remove_autoloads_completion_and_binary() {
    printf '#!/bin/bash\n' > "${__stub_dir__}/myscript-completion.sh"

    assert_equals \
        "remove-autoload:${HOME}/.zshrc:myscript
remove-autoload:${HOME}/.bashrc:myscript
remove-autoload:${HOME}/.profile:myscript
sudo rm -f /usr/local/bin/myscript" \
        "$(_uninstall "${__script__}")"
}

test_uninstall_should_remove_completion_file() {
    printf '#!/bin/bash\n' > "${__stub_dir__}/myscript-completion.sh"

    _uninstall "${__script__}" >/dev/null

    assert_fails "[ -f '${__stub_dir__}/myscript-completion.sh' ]"
}

test_uninstall_fails_with_missing_argument() {
    assert_fails "_uninstall"
    assert_equals '_uninstall: some mandatory parameter is missing' "$(_uninstall 2>&1)"
}

test_uninstall_fails_with_nonexistent_file() {
    assert_fails "_uninstall 'nonexistent.sh'"
}

test_uninstall_fails_with_too_many_arguments() {
    assert_fails "_uninstall 'a' 'b' 'c'"
    assert_equals '_uninstall: too many arguments (3)' "$(_uninstall 'a' 'b' 'c' 2>&1)"
}

#--------------------------------------------------
# Update
#--------------------------------------------------

test_update_should_download_then_reinstall_script() {
    _is_installed() { [ "$1" = 'curl' ]; }
    _uninstall() { printf 'uninstall:%s:%s\n' "$1" "$2"; }
    _install() { printf 'install:%s:%s:%s\n' "$1" "$2" "$3"; }
    curl() { printf 'new content'; }

    assert_equals \
        "uninstall:$(realpath "${__script__}"):myscript
install:$(realpath "${__script__}"):myscript:false" \
        "$(_update "${__script__}" 'https://example.com/myscript.sh')"
    assert_equals 'new content' "$(cat "${__script__}")"
}

test_update_fails_when_no_downloader_is_available() {
    assert_fails "_update '${__script__}' 'https://example.com/myscript.sh'"
    assert_equals "\"${0}\" requires curl, try: \"sudo apt-get install -y curl\"" "$(_update "${__script__}" 'https://example.com/myscript.sh' 2>&1)"
}

test_update_fails_with_missing_arguments() {
    assert_fails "_update"
    assert_equals '_update: some mandatory parameter is missing' "$(_update 2>&1)"
}

test_update_fails_with_nonexistent_file() {
    assert_fails "_update 'nonexistent.sh' 'https://example.com/myscript.sh'"
}

test_update_fails_with_too_many_arguments() {
    assert_fails "_update 'a' 'b' 'c' 'd' 'e'"
    assert_equals '_update: too many arguments (5)' "$(_update 'a' 'b' 'c' 'd' 'e' 2>&1)"
}

#--------------------------------------------------
# Self commands
#--------------------------------------------------

test_self_install_should_install_current_script() {
    _install() { printf 'install:%s:%s:%s\n' "$1" "$2" "$3"; }
    unset ALIAS global

    assert_equals "install:${0}:bash_unit:false" "$(self_install)"
}

test_self_uninstall_should_uninstall_current_script() {
    _uninstall() { printf 'uninstall:%s:%s\n' "$1" "$2"; }
    unset ALIAS

    assert_equals "uninstall:${0}:bash_unit" "$(self_uninstall)"
}

test_self_update_should_update_current_script() {
    _update() { printf 'update:%s:%s:%s:%s\n' "$1" "$2" "$3" "$4"; }
    unset ALIAS global
    __update_link__='https://example.com/myscript.sh'

    assert_equals \
        "update:${0}:https://example.com/myscript.sh:bash_unit:false" \
        "$(self_update)"
}

test_self_update_fails_without_update_tag() {
    unset ALIAS global
    __update_link__=''

    assert_fails "self_update"
    assert_equals 'cannot update: "@update" missing' "$(self_update 2>&1)"
}
