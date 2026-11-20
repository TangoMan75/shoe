#!/bin/sh

## Run tests
##
## @namespace recipes/entrypoint/app
## @requires bash_unit find sort
## @depends src/shell/colors/_echo_info
## @assumes test_folder
tests() {
    find "${test_folder}" -type f -name 'test_*.sh' | LC_ALL=C sort | while read -r FILE
    do
        _echo_info "./tests/bash_unit -f tap \"${FILE}\"\n"
        ./tests/bash_unit -f tap "${FILE}"
    done
}

