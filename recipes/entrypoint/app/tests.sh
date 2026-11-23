#!/bin/sh

## Run tests
##
## The run fails as soon as one test file fails, whatever its position
## in the list: the loop reads the list from a temporary file so its
## status survives, and a failing file is remembered.
##
## @namespace recipes/entrypoint/app
## @requires bash_unit find mktemp rm sort
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
tests() {
    # Reading the list from a file keeps the loop in this shell: in a
    # pipeline its status and its variables would be lost.
    __list__="$(mktemp)" || return 1

    # The list goes straight to the file: no intermediate variable, and
    # emptiness is checked on exactly what the loop is about to read.
    find "./tests" -type f -name 'test_*.sh' | LC_ALL=C sort > "${__list__}"
    if [ ! -s "${__list__}" ]; then
        _echo_error "no test file found in \"./tests\"\n"
        rm -f -- "${__list__}"

        return 1
    fi

    __status__=0
    while read -r file_path
    do
        _echo_info "./tests/bash_unit -f tap \"${file_path}\"\n"
        if ! ./tests/bash_unit -f tap "${file_path}"; then
            __status__=1
        fi
    done < "${__list__}"

    rm -f -- "${__list__}"

    return "${__status__}"
}

