#!/bin/sh

## Run tests
##
## {
##   "requires": [
##     "bash_unit"
##   ],
##   "depends": [
##     "echo_info"
##   ]
## }
tests() {
    find "${test_folder}" -type f -name 'test_*.sh' | sort -t '\0' -n | while read -r FILE
    do
        echo_info "./tests/bash_unit -f tap \"${FILE}\"\n"
        ./tests/bash_unit -f tap "${FILE}"
    done
}

