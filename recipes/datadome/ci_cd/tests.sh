#!/bin/sh

## Run tests
##
## {
##   "namespace": "ci_cd",
##   "requires": [
##     "php"
##   ],
##   "depends": [
##     "_sf_test"
##   ],
##   "assumes": [
##     "file"
##   ]
## }
tests() {
    if [ "${file}" ]; then
        _sf_test "${file}"

        return 0
    fi

    _sf_test
}

