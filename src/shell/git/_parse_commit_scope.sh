#!/bin/sh

## Parse commit scope
##
## Parse the commit scope from a conventional commit message,
## eg: feat(foobar): FooBar (FOO-01) => foobar.
##
## @namespace src/shell/git
## @requires awk command printf
## @depends src/shell/colors/_echo_danger
## @param {str} <COMMIT_MESSAGE> (required) The conventional commit message to parse.
_parse_commit_scope() {
    # Check awk installation
    if ! command -v awk >/dev/null 2>&1; then
        _echo_danger 'error: awk required, enter: "sudo apt-get install -y awk" to install\n'

        return 1
    fi

    printf '%s' "$1" | awk -F '[^a-z_-]' '/^[a-z()_-]*!?: /{print $2}'
}

