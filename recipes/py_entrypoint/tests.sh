#!/bin/sh

## Run tests
##
## @namespace recipes/py_entrypoint
## @requires find python3 sort
## @depends src/shell/colors/_echo_info
tests() {
    find ./tests -type f -name 'test_*.py' | sort -t '\0' -n | while read -r _file
    do
        _echo_info "python3 \"${_file}\"\n"
        python3 "${_file}"
    done
}

