#!/bin/sh

## Run tests
##
## @namespace recipes/datadome/ci_cd
## @depends src/shell/symfony/_sf_test.sh
## @assumes file
tests() {
    if [ "${file}" ]; then
        _sf_test "${file}"

        return 0
    fi

    _sf_test
}

