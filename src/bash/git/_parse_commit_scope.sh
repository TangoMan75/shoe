#!/bin/bash

## Parse commit scope
##
## Parse the commit scope from a conventional commit message, eg: feat(foobar): FooBar (FOO-01) => foobar.
##
## @namespace src/bash/git
## @requires awk command echo
## @depends src/shell/colors/_echo_danger
## @param {str} <COMMIT_MESSAGE> (required) The conventional commit message to parse.
function _parse_commit_scope() {
    # Check awk installation
    if [ ! -x "$(command -v awk)" ]; then
        _echo_danger 'error: awk required, enter: "sudo apt-get install -y awk" to install\n'
        return 1
    fi

    echo -n "$1" | awk -F '[^a-z_-]' '/^[a-z()_-]*!?: /{print $2}'
}

