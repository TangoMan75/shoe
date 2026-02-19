#!/bin/sh

## Run linter (sniff)
##
## {
##   "namespace": "ci_cd",
##   "depends": [
##     "_sf_lint"
##   ]
## }
lint() {
    _sf_lint
}

