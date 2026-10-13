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

# https://github.com/pgrange/bash_unit
#
#     assert "test -e /tmp/the_file"
#     assert_fails "grep this /tmp/the_file" "should not write 'this' in /tmp/the_file"
#     assert_status_code 25 code # 127: command not found; 126: command not executable
#     assert_equals "a string" "another string" "a string should be another string"
#     assert_not_equals "a string" "a string" "a string should be different from another string"
#     fake ps echo hello world

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
src_file="${repository_root}/src/bash/git/_get_latest_release.sh"
colors_dir="${repository_root}/src/shell/colors"

# shellcheck source=/dev/null
. "${src_file}"
# shellcheck source=/dev/null
. "${colors_dir}/constants_echo_colors.sh"
for _echo_source_file in "${colors_dir}"/_echo_*.sh; do
    # shellcheck source=/dev/null
    . "${_echo_source_file}"
done
unset _echo_source_file

test_script_execution_should_return_expected_status_code() {
    assert_status_code 0 "${src_file}"
}

test__get_latest_release_missing_arguments_should_return_expected_error() {
    assert_fails "$(_get_latest_release)"
}

setup() {
    # create a stub curl executable (shell functions fail the [ -x ] check in _get_latest_release)
    STUB_DIR=$(mktemp -d)
    cat > "${STUB_DIR}/curl" <<'EOF'
#!/bin/bash
if [ -n "${FAKE_CURL_TAG:-}" ]; then
    printf '{"tag_name": "%s"}' "${FAKE_CURL_TAG}"
fi
EOF
    chmod +x "${STUB_DIR}/curl"
    PATH="${STUB_DIR}:${PATH}"
}

teardown() {
    rm -rf "${STUB_DIR}"
    unset FAKE_CURL_TAG
}

test__get_latest_release_should_strip_version_prefix() {
    export FAKE_CURL_TAG=version26.3.0
    assert_equals "26.3.0" "$(_get_latest_release owner/repository)"
}

test__get_latest_release_should_strip_v_prefix() {
    export FAKE_CURL_TAG=v1.2.3
    assert_equals "1.2.3" "$(_get_latest_release owner/repository)"
}

test__get_latest_release_should_return_plain_tag() {
    export FAKE_CURL_TAG=1.2.3
    assert_equals "1.2.3" "$(_get_latest_release owner/repository)"
}
