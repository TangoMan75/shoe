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

src_dir="../../../src/shell/compatibility"

source "${src_dir}/_is_android.sh"
source "${src_dir}/_is_bsd.sh"
source "${src_dir}/_is_cygwin.sh"
source "${src_dir}/_is_darwin.sh"
source "${src_dir}/_is_linux.sh"
source "${src_dir}/_is_msys.sh"
source "${src_dir}/_is_wsl.sh"

#--------------------------------------------------
# Mock functions
#--------------------------------------------------

uname() {
    case "$1" in
        -o) printf '%s\n' "${__uname_o__:-GNU/Linux}" ;;
        *) printf '%s\n' "${__uname_s__:-Linux}" ;;
    esac
}

__uname_o__='GNU/Linux'
__uname_s__='Linux'

#--------------------------------------------------

teardown() {
    unset -f grep 2>/dev/null || true
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_dir}/_is_darwin.sh"
}

#--------------------------------------------------
# Android
#--------------------------------------------------

test_is_android_returns_true_with_android_data() {
    ANDROID_DATA='/data'
    unset ANDROID_ROOT

    assert "_is_android"
}

test_is_android_returns_true_with_android_root() {
    ANDROID_ROOT='/system'
    unset ANDROID_DATA

    assert "_is_android"
}

test_is_android_returns_true_for_uname_o_android() {
    unset ANDROID_DATA ANDROID_ROOT
    __uname_o__='Android'

    assert "_is_android"
}

test_is_android_returns_false_for_desktop_linux() {
    unset ANDROID_DATA ANDROID_ROOT
    __uname_o__='GNU/Linux'

    assert_fails "_is_android"
}

#--------------------------------------------------
# BSD
#--------------------------------------------------

test_is_bsd_returns_true_for_freebsd() {
    __uname_s__='FreeBSD'

    assert "_is_bsd"
}

test_is_bsd_returns_false_for_linux() {
    __uname_s__='Linux'

    assert_fails "_is_bsd"
}

#--------------------------------------------------
# Cygwin
#--------------------------------------------------

test_is_cygwin_returns_true_for_cygwin() {
    __uname_s__='CYGWIN_NT-10.0'

    assert "_is_cygwin"
}

test_is_cygwin_returns_false_for_linux() {
    __uname_s__='Linux'

    assert_fails "_is_cygwin"
}

#--------------------------------------------------
# Darwin
#--------------------------------------------------

test_is_darwin_returns_true_for_darwin() {
    __uname_s__='Darwin'

    assert "_is_darwin"
}

test_is_darwin_returns_false_for_linux() {
    __uname_s__='Linux'

    assert_fails "_is_darwin"
}

#--------------------------------------------------
# Linux
#--------------------------------------------------

test_is_linux_returns_true_for_linux() {
    __uname_s__='Linux'

    assert "_is_linux"
}

test_is_linux_returns_false_for_darwin() {
    __uname_s__='Darwin'

    assert_fails "_is_linux"
}

#--------------------------------------------------
# MSYS
#--------------------------------------------------

test_is_msys_returns_true_for_msys() {
    __uname_s__='MSYS_NT-10.0'

    assert "_is_msys"
}

test_is_msys_returns_true_for_mingw() {
    __uname_s__='MINGW64_NT-10.0'

    assert "_is_msys"
}

test_is_msys_returns_false_for_linux() {
    __uname_s__='Linux'

    assert_fails "_is_msys"
}

#--------------------------------------------------
# WSL
#--------------------------------------------------

test_is_wsl_returns_true_with_distro_name() {
    WSL_DISTRO_NAME='Ubuntu'
    unset WSL_INTEROP

    assert "_is_wsl"
}

test_is_wsl_returns_true_with_interop() {
    WSL_INTEROP='/run/WSL/1_interop'
    unset WSL_DISTRO_NAME

    assert "_is_wsl"
}

test_is_wsl_returns_false_without_markers() {
    unset WSL_DISTRO_NAME WSL_INTEROP
    grep() { return 1; }

    assert_fails "_is_wsl"
}

