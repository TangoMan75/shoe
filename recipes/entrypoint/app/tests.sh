#!/bin/sh

## {
##   "namespace": "recipes/entrypoint/app",
##   "summary": "Run tests",
##   "requires": [
##     "bash_unit",
##     "find",
##     "sort"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
tests() {
    find "${test_folder}" -type f -name 'test_*.sh' | sort -t '\0' -n | while read -r FILE
    do
        _echo_info "./tests/bash_unit -f tap \"${FILE}\"\n"
        ./tests/bash_unit -f tap "${FILE}"
    done
}

