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
    test_dir=$(mktemp -d)
    python3 ../../shoemaker.py build ../fixtures/scoped/scoped.shoe \
        --destination "${test_dir}" >/dev/null
    script="${test_dir}/scoped.sh"
    chmod 775 "${script}"
}

teardown_suite() {
    rm -rf "${test_dir}"
}

#--------------------------------------------------
# Options
#--------------------------------------------------

test_global_options_should_apply_to_every_command() {
    assert_equals \
        'add: store=store.tsv output=csv verbose=false name= url= force=false' \
        "$(_remove_colors "$(${script} add --output csv)")"
}

test_command_option_should_apply_to_its_command() {
    assert_equals \
        'add: store=store.tsv output=table verbose=false name=shoe url=https://example.com force=false' \
        "$(_remove_colors "$(${script} add --name shoe --url https://example.com)")"
}

test_command_option_should_default_to_annotation_value() {
    assert_equals \
        'add: store=store.tsv output=table verbose=false name= url= force=false' \
        "$(_remove_colors "$(${script} add)")"
}

test_command_option_should_accept_short_alias() {
    assert_equals \
        'add: store=store.tsv output=table verbose=false name=shoe url=https://example.com force=false' \
        "$(_remove_colors "$(${script} add -n shoe -u https://example.com)")"
}

test_command_option_should_be_rejected_for_another_command() {
    assert_fails "${script} search --name shoe"
    assert_equals \
        'error: "--name" is not a valid parameter' \
        "$(_remove_colors "$(${script} search --name shoe 2>&1)")"
}

test_command_option_should_be_rejected_without_command() {
    assert_fails "${script} --name shoe"
    assert_equals \
        'error: "--name" is not a valid parameter' \
        "$(_remove_colors "$(${script} --name shoe 2>&1)")"
}

test_command_option_should_work_before_command() {
    assert_equals \
        'add: store=store.tsv output=table verbose=false name=shoe url=https://example.com force=false' \
        "$(_remove_colors "$(${script} --name shoe --url https://example.com add)")"
}

test_command_option_value_should_not_be_parsed_as_command() {
    assert_equals \
        'add: store=store.tsv output=table verbose=false name=search url= force=false' \
        "$(_remove_colors "$(${script} add --name search)")"
}

test_commands_with_same_option_name_should_bind_per_command() {
    assert_equals 'alpha: mode=alpha force=false' \
        "$(_remove_colors "$(${script} alpha)")"

    assert_equals 'beta: mode=beta force=false' \
        "$(_remove_colors "$(${script} beta)")"

    assert_equals 'alpha: mode=one force=false' \
        "$(_remove_colors "$(${script} alpha --mode one)")"

    assert_equals 'beta: mode=two force=false' \
        "$(_remove_colors "$(${script} beta --mode two)")"
}

test_commands_with_same_flag_name_should_bind_per_command() {
    assert_equals 'alpha: mode=alpha force=true' \
        "$(_remove_colors "$(${script} alpha --force)")"

    assert_equals 'beta: mode=beta force=true' \
        "$(_remove_colors "$(${script} beta --force)")"
}

test_multiple_commands_should_fail_with_expected_error_message() {
    assert_fails "${script} alpha beta"
    assert_equals \
        'error: only one command at a time' \
        "$(_remove_colors "$(${script} alpha beta 2>&1)")"
}

test_search_option_should_accept_short_alias() {
    assert_equals \
        'search: store=store.tsv output=table verbose=false term=git' \
        "$(_remove_colors "$(${script} search -t git)")"
}

test_global_option_should_accept_implicit_shorthand() {
    assert_equals \
        'add: store=other.tsv output=table verbose=false name= url= force=false' \
        "$(_remove_colors "$(${script} add -s other.tsv)")"
}

test_command_option_should_validate_against_annotation_constraint() {
    assert_fails "${script} add --name 'bad name'"
    assert_equals \
        'error: invalid "name", expected "/^[A-Za-z0-9._-]+$/", "bad name" given' \
        "$(_remove_colors "$(${script} add --name 'bad name' 2>&1)")"
}

#--------------------------------------------------
# Flags
#--------------------------------------------------

test_global_flag_should_apply_to_every_command() {
    assert_equals \
        'add: store=store.tsv output=table verbose=true name= url= force=false' \
        "$(_remove_colors "$(${script} add --verbose)")"
}

test_global_flag_should_accept_implicit_shorthand() {
    assert_equals \
        'add: store=store.tsv output=table verbose=true name= url= force=false' \
        "$(_remove_colors "$(${script} add -v)")"
}

test_command_flag_should_apply_to_its_command() {
    assert_equals \
        'add: store=store.tsv output=table verbose=false name= url= force=true' \
        "$(_remove_colors "$(${script} add --force)")"
}

test_command_flag_should_accept_short_alias() {
    assert_equals \
        'list: store=store.tsv output=table verbose=false all=true' \
        "$(_remove_colors "$(${script} list -a)")"
}

test_command_flag_should_be_rejected_for_another_command() {
    assert_fails "${script} add --all"
    assert_equals \
        'error: "--all" is not a valid parameter' \
        "$(_remove_colors "$(${script} add --all 2>&1)")"
}

#--------------------------------------------------
# Help
#--------------------------------------------------

test_command_help_should_list_only_command_specific_parameters() {
    helper="$(_remove_colors "$(${script} help add)")"

    assert "printf '%s' \"${helper}\" | grep -q -- '--name'"
    assert "printf '%s' \"${helper}\" | grep -q -- '--url'"
    assert "printf '%s' \"${helper}\" | grep -q -- '--force'"
    assert "! printf '%s' \"${helper}\" | grep -q -- '--term'"
    assert "! printf '%s' \"${helper}\" | grep -q -- '--all'"
}

test_search_help_should_list_only_search_parameters() {
    helper="$(_remove_colors "$(${script} help search)")"

    assert "printf '%s' \"${helper}\" | grep -q -- '--term'"
    assert "! printf '%s' \"${helper}\" | grep -q -- '--name'"
    assert "! printf '%s' \"${helper}\" | grep -q -- '--force'"
}

#--------------------------------------------------
# Errors
#--------------------------------------------------

test_unknown_option_should_fail_with_expected_error_message() {
    assert_fails "${script} add --tango"
    assert_equals \
        'error: "--tango" is not a valid parameter' \
        "$(_remove_colors "$(${script} add --tango 2>&1)")"
}

test_unknown_command_should_fail_with_expected_error_message() {
    assert_fails "${script} tango"
    assert_equals \
        'error: "tango" is not a valid command' \
        "$(_remove_colors "$(${script} tango 2>&1)")"
}

test_command_shorthand_should_fail() {
    assert_fails "${script} a"
    assert_equals \
        'error: "a" is not a valid command' \
        "$(_remove_colors "$(${script} a 2>&1)")"
}

test_option_should_fail_when_value_is_missing() {
    assert_fails "${script} add --name"
    assert_equals \
        'error: "--name" requires value' \
        "$(_remove_colors "$(${script} add --name 2>&1)")"
}
