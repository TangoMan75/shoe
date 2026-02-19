#!/bin/sh

## {
##   "namespace": "recipes/datadome/ci_cd",
##   "summary": "Check security issues in project dependencies (symfony-cli)",
##   "depends": [
##     "src/shell/symfony/_sf_security"
##   ]
## }
security() {
    _sf_security
}

