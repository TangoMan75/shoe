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

source ../helper/_remove_colors.sh

#--------------------------------------------------

setup_suite() {
    __test_dir__=$(mktemp -d)
    python3 ../../shoemaker.py build ../fixtures/scoped/scoped.shoe \
        --destination "${__test_dir__}" --sh >/dev/null
    __script__="${__test_dir__}/scoped.sh"
    chmod 775 "${__script__}"
}

teardown_suite() {
    rm -rf "${__test_dir__}"
}

#--------------------------------------------------
# Options
#--------------------------------------------------

test_global_options_should_apply_to_every_command() {
    assert_equals \
        'add: store=store.tsv output=csv verbose=false name= url= force=false' \
        "$(_remove_colors "$(${__script__} add --output csv)")"
}

test_command_option_should_apply_to_its_command() {
    assert_equals \
        'add: store=store.tsv output=table verbose=false name=shoe url=https://example.com force=false' \
        "$(_remove_colors "$(${__script__} add --name shoe --url https://example.com)")"
}

test_command_option_should_default_to_annotation_value() {
    assert_equals \
        'add: store=store.tsv output=table verbose=false name= url= force=false' \
        "$(_remove_colors "$(${__script__} add)")"
}

test_command_option_should_accept_short_alias() {
    assert_equals \
        'add: store=store.tsv output=table verbose=false name=shoe url=https://example.com force=false' \
        "$(_remove_colors "$(${__script__} add -n shoe -u https://example.com)")"
}

test_command_option_should_be_rejected_for_another_command() {
    assert_fails "$(${__script__} search --name shoe)"
    assert_equals \
        'error: "--name" is not a valid parameter' \
        "$(_remove_colors "$(${__script__} search --name shoe 2>&1)")"
}

test_command_option_should_be_rejected_without_command() {
    assert_fails "$(${__script__} --name shoe)"
    assert_equals \
        'error: "--name" is not a valid parameter' \
        "$(_remove_colors "$(${__script__} --name shoe 2>&1)")"
}

test_command_option_should_work_before_command() {
    assert_equals \
        'add: store=store.tsv output=table verbose=false name=shoe url=https://example.com force=false' \
        "$(_remove_colors "$(${__script__} --name shoe --url https://example.com add)")"
}

test_command_option_value_should_not_be_parsed_as_command() {
    assert_equals \
        'add: store=store.tsv output=table verbose=false name=search url= force=false' \
        "$(_remove_colors "$(${__script__} add --name search)")"
}

test_command_option_without_alias_should_accept_implicit_shorthand() {
    assert_equals \
        'search: store=store.tsv output=table verbose=false term=git' \
        "$(_remove_colors "$(${__script__} search -t git)")"
}

test_command_option_should_validate_against_annotation_constraint() {
    assert_fails "$(${__script__} add --name 'bad name')"
    assert_equals \
        'error: invalid "name", expected "/^[A-Za-z0-9._-]+$/", "bad name" given' \
        "$(_remove_colors "$(${__script__} add --name 'bad name' 2>&1)")"
}

#--------------------------------------------------
# Flags
#--------------------------------------------------

test_global_flag_should_apply_to_every_command() {
    assert_equals \
        'add: store=store.tsv output=table verbose=true name= url= force=false' \
        "$(_remove_colors "$(${__script__} add --verbose)")"
}

test_command_flag_should_apply_to_its_command() {
    assert_equals \
        'add: store=store.tsv output=table verbose=false name= url= force=true' \
        "$(_remove_colors "$(${__script__} add --force)")"
}

test_command_flag_should_accept_short_alias() {
    assert_equals \
        'list: store=store.tsv output=table verbose=false all=true' \
        "$(_remove_colors "$(${__script__} list -a)")"
}

test_command_flag_should_be_rejected_for_another_command() {
    assert_fails "$(${__script__} add --all)"
    assert_equals \
        'error: "--all" is not a valid parameter' \
        "$(_remove_colors "$(${__script__} add --all 2>&1)")"
}

#--------------------------------------------------
# Help
#--------------------------------------------------

test_command_help_should_list_only_command_specific_parameters() {
    helper="$(_remove_colors "$(${__script__} help add)")"

    assert "printf '%s' \"${helper}\" | grep -q -- '--name'"
    assert "printf '%s' \"${helper}\" | grep -q -- '--url'"
    assert "printf '%s' \"${helper}\" | grep -q -- '--force'"
    assert "! printf '%s' \"${helper}\" | grep -q -- '--term'"
    assert "! printf '%s' \"${helper}\" | grep -q -- '--all'"
}

test_search_help_should_list_only_search_parameters() {
    helper="$(_remove_colors "$(${__script__} help search)")"

    assert "printf '%s' \"${helper}\" | grep -q -- '--term'"
    assert "! printf '%s' \"${helper}\" | grep -q -- '--name'"
    assert "! printf '%s' \"${helper}\" | grep -q -- '--force'"
}

#--------------------------------------------------
# Errors
#--------------------------------------------------

test_unknown_option_should_fail_with_expected_error_message() {
    assert_fails "$(${__script__} add --tango)"
    assert_equals \
        'error: "--tango" is not a valid parameter' \
        "$(_remove_colors "$(${__script__} add --tango 2>&1)")"
}

test_unknown_command_should_fail_with_expected_error_message() {
    assert_fails "$(${__script__} tango)"
    assert_equals \
        'error: "tango" is not a valid command' \
        "$(_remove_colors "$(${__script__} tango 2>&1)")"
}

test_option_should_fail_when_value_is_missing() {
    assert_fails "$(${__script__} add --name)"
    assert_equals \
        'error: "--name" requires value' \
        "$(_remove_colors "$(${__script__} add --name 2>&1)")"
}
