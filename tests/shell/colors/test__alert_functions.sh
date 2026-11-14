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

source "${colors_dir}/_alert_primary.sh"
source "${colors_dir}/_alert_secondary.sh"
source "${colors_dir}/_alert_success.sh"
source "${colors_dir}/_alert_danger.sh"
source "${colors_dir}/_alert_warning.sh"
source "${colors_dir}/_alert_info.sh"
source "${colors_dir}/_alert_light.sh"
source "${colors_dir}/_alert_dark.sh"

#--------------------------------------------------
# Mock constants
#--------------------------------------------------

_ALERT_DANGER=''
_ALERT_DARK=''
_ALERT_INFO=''
_ALERT_LIGHT=''
_ALERT_PRIMARY=''
_ALERT_SECONDARY=''
_ALERT_SUCCESS=''
_ALERT_WARNING=''
_EOL=''

#--------------------------------------------------
# Helpers
#--------------------------------------------------

_expected_alert() {
    printf '%64s %-63s%64s\n' '' "$1" ''
}

#--------------------------------------------------

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "bash ${colors_dir}/_alert_primary.sh"
}

#--------------------------------------------------

test_alert_primary_should_print_centered_banner() {
    assert_equals "$(_expected_alert 'hello')" "$(_alert_primary 'hello')"
}

test_alert_secondary_should_print_centered_banner() {
    assert_equals "$(_expected_alert 'hello')" "$(_alert_secondary 'hello')"
}

test_alert_success_should_print_centered_banner() {
    assert_equals "$(_expected_alert 'hello')" "$(_alert_success 'hello')"
}

test_alert_danger_should_print_centered_banner() {
    assert_equals "$(_expected_alert 'hello')" "$(_alert_danger 'hello')"
}

test_alert_warning_should_print_centered_banner() {
    assert_equals "$(_expected_alert 'hello')" "$(_alert_warning 'hello')"
}

test_alert_info_should_print_centered_banner() {
    assert_equals "$(_expected_alert 'hello')" "$(_alert_info 'hello')"
}

test_alert_light_should_print_centered_banner() {
    assert_equals "$(_expected_alert 'hello')" "$(_alert_light 'hello')"
}

test_alert_dark_should_print_centered_banner() {
    assert_equals "$(_expected_alert 'hello')" "$(_alert_dark 'hello')"
}

test_alert_should_handle_long_text() {
    assert_equals "$(_expected_alert 'a longer alert message')" "$(_alert_primary 'a longer alert message')"
}
