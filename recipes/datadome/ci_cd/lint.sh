#!/bin/sh

## {
##   "namespace": "recipes/datadome/ci_cd",
##   "summary": "Run linter (sniff)",
##   "depends": [
##     "src/shell/symfony/_sf_lint"
##   ]
## }
lint() {
    _sf_lint
}

