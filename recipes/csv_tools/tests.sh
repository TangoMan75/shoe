#!/bin/sh

## Run tests
##
## {
##   "requires": [
##     "find",
##     "python3"
##   ],
##   "depends": [
##     "_echo_info"
##   ]
## }
tests() {
    find ./tests -type f -name 'test_*.py' | sort -t '\0' -n | while read -r FILE
    do
        _echo_info "python3 \"${FILE}\"\n"
        python3 "${FILE}"
    done
}

