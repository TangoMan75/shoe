#!/bin/sh

## Sniff errors with linters
##
## {
##   "namespace": "ci_cd",
##   "depends": [
##     "lint_shell",
##     "lint_yaml"
##   ]
## }
lint() {
    lint_shell
    lint_yaml
}

