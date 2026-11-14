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

colors_dir="../../../src/shell/colors"

#--------------------------------------------------

test_echo_colors_constants_should_be_defined() {
    source "${colors_dir}/constants_echo_colors.sh"

    assert_equals '\033[97m' "${_PRIMARY}"
    assert_equals '\033[94m' "${_SECONDARY}"
    assert_equals '\033[32m' "${_SUCCESS}"
    assert_equals '\033[31m' "${_DANGER}"
    assert_equals '\033[33m' "${_WARNING}"
    assert_equals '\033[95m' "${_INFO}"
    assert_equals '\033[47;90m' "${_LIGHT}"
    assert_equals '\033[40;37m' "${_DARK}"
    assert_equals '\033[0m' "${_DEFAULT}"
    assert_equals '\033[0m\n' "${_EOL}"
}

test_alert_colors_constants_should_be_defined() {
    source "${colors_dir}/constants_alert_colors.sh"

    assert_equals '\033[1;104;97m' "${_ALERT_PRIMARY}"
    assert_equals '\033[1;45;97m' "${_ALERT_SECONDARY}"
    assert_equals '\033[1;42;97m' "${_ALERT_SUCCESS}"
    assert_equals '\033[1;41;97m' "${_ALERT_DANGER}"
    assert_equals '\033[1;43;97m' "${_ALERT_WARNING}"
    assert_equals '\033[1;44;97m' "${_ALERT_INFO}"
    assert_equals '\033[1;47;90m' "${_ALERT_LIGHT}"
    assert_equals '\033[1;40;37m' "${_ALERT_DARK}"
}

test_alert_colors_sf_constants_should_override_values() {
    source "${colors_dir}/constants_alert_colors_sf.sh"

    assert_equals '\033[104;37m' "${_ALERT_PRIMARY}"
    assert_equals '\033[45;37m' "${_ALERT_SECONDARY}"
    assert_equals '\033[42;30m' "${_ALERT_SUCCESS}"
    assert_equals '\033[41;37m' "${_ALERT_DANGER}"
    assert_equals '\033[43;30m' "${_ALERT_WARNING}"
    assert_equals '\033[44;37m' "${_ALERT_INFO}"
    assert_equals '\033[47;90m' "${_ALERT_LIGHT}"
    assert_equals '\033[40;37m' "${_ALERT_DARK}"
}

test_constants_files_should_not_produce_output() {
    assert_equals '' "$(source "${colors_dir}/constants_echo_colors.sh")"
    assert_equals '' "$(source "${colors_dir}/constants_alert_colors.sh")"
    assert_equals '' "$(source "${colors_dir}/constants_alert_colors_sf.sh")"
}
